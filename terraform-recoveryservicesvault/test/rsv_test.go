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

	// website::tag::3:: Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	vaultName := terraform.Output(t, terraformOptions, "recovery_service_vault_name")
	policyVmName := terraform.Output(t, terraformOptions, "backup_policy_vm_name")

	// website::tag::4:: Verify the recovery services resources
	exists := azure.RecoveryServicesVaultExists(t, vaultName, resourceGroupName, subscriptionID)
	assert.True(t, exists, "vault does not exist")

	policyList := azure.GetRecoveryServicesVaultBackupPolicyList(t, vaultName, resourceGroupName, subscriptionID)
	assert.NotNil(t, policyList, "vault backup policy list is nil")

	vmPolicyList := azure.GetRecoveryServicesVaultBackupProtectedVMList(t, policyVmName, vaultName, resourceGroupName, subscriptionID)
	assert.NotNil(t, vmPolicyList, "vault backup policy list for protected vm is nil")
}
