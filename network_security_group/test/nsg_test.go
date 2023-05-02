//go:build azure
// +build azure

// NOTE: We use build tags to differentiate azure testing because we currently do not have azure access setup for
// CircleCI.

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureKeyVaultExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "./",
		VarFiles:     []string{"terraform.tfvars"},
	})

	// GenOutput generates the output string to be asserted against
	GenOutput := func(outputName string) (generated string) {
		generated = terraform.Output(t, terraformOptions, outputName)
		return
	}

	// website::tag::6:: At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	nsgName := terraform.Output(t, terraformOptions, "nsg_name")
	sshRuleName := terraform.Output(t, terraformOptions, "ssh_rule_name")
	httpRuleName := terraform.Output(t, terraformOptions, "http_rule_name")

	// A default NSG has 6 rules, and we have two custom rules for a total of 8
	rules, err := azure.GetAllNSGRulesE(resourceGroupName, nsgName, "")
	assert.NoError(t, err)
	assert.Equal(t, 8, len(rules.SummarizedRules))

	// We should have a rule for allowing ssh
	sshRule := rules.FindRuleByName(sshRuleName)

	// That rule should allow port 22 inbound
	assert.True(t, sshRule.AllowsDestinationPort(t, "22"))

	// But should not allow 80 inbound
	assert.False(t, sshRule.AllowsDestinationPort(t, "80"))

	// SSh is allowed from any port
	assert.True(t, sshRule.AllowsSourcePort(t, "*"))

	// We should have a rule for blocking HTTP
	httpRule := rules.FindRuleByName(httpRuleName)

	// This rule should BLOCK port 80 inbound
	assert.False(t, httpRule.AllowsDestinationPort(t, "80"))
}
