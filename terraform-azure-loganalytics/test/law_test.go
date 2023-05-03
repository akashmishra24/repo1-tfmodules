//go:build azure
// +build azure

// NOTE: We use build tags to differentiate azure testing because we currently do not have azure access setup for
// CircleCI.

package test

import (
	"strconv"
	"strings"
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

	// website::tag::3:: Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	workspaceName := terraform.Output(t, terraformOptions, "loganalytics_workspace_name")
	sku := terraform.Output(t, terraformOptions, "loganalytics_workspace_sku")
	retentionPeriodString := terraform.Output(t, terraformOptions, "loganalytics_workspace_retention")

	// website::tag::4:: Verify the Log Analytics properties and ensure it matches the output.
	workspaceExists := azure.LogAnalyticsWorkspaceExists(t, workspaceName, resourceGroupName, subscriptionID)
	assert.True(t, workspaceExists, "log analytics workspace not found.")

	actualWorkspace := azure.GetLogAnalyticsWorkspace(t, workspaceName, resourceGroupName, subscriptionID)

	actualSku := string(actualWorkspace.Sku.Name)
	assert.Equal(t, strings.ToLower(sku), strings.ToLower(actualSku), "log analytics sku mismatch")

	actualRetentionPeriod := *actualWorkspace.RetentionInDays
	expectedPeriod, _ := strconv.ParseInt(retentionPeriodString, 10, 32)
	assert.Equal(t, int32(expectedPeriod), actualRetentionPeriod, "log analytics retention period mismatch")
}
