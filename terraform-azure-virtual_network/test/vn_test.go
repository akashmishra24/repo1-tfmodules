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

	// Run `terraform output` to get the values of output variables
	resourceGroupName := GenOutput("resource_group_name")
	VNetName := GenOutput("virtual_network_name")
	SubnetName := GenOutput("subnet_name")
	firewallSubnetName := GenOutput("firewall_name")
	gatewaySubnetName := GenOutput("gateway_name")
	// Tests are separated into subtests to differentiate integrated tests and pure resource tests

	// Integrated network resource tests
	assert.Equal(t, "azngcpocnp-networking", resourceGroupName)
	assert.Equal(t, "", VNetName)
	assert.Equal(t, "", SubnetName)
	assert.Equal(t, "", firewallSubnetName)
	assert.Equal(t, "", gatewaySubnetName)

}