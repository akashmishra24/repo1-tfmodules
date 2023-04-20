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

func TestTerraformStorageAcct(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "./",
		VarFiles:     []string{"terratest_input.tfvars"},
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
	resourceGroupName := GenOutput("resource_group")
	keyVaultName := GenOutput("key_vault_name")
	secretName := GenOutput("secret_name")
	keyName := GenOutput("key_name")
	certificateName := GenOutput("certificate_name")

	// website::tag::4:: Determine whether the keyvault exists
	// keyVault := azure.GetKeyVault(t, resourceGroupName, keyVaultName, "")
	assert.Equal(t, "[tf-strg-acct-testing]", resourceGroupName)
	assert.Equal(t, "[kv-eastus-testing]", keyVaultName)

	// website::tag::5:: Determine whether the secret, key, and certificate exists
	//secretExists := azure.KeyVaultSecretExists(t, keyVaultName, expectedSecretName)
	assert.True(t, secretName, "kv-secret does not exist")

	//keyExists := azure.KeyVaultKeyExists(t, keyVaultName, expectedKeyName)
	assert.True(t, keyName, "kv-key does not exist")

	//certificateExists := azure.KeyVaultCertificateExists(t, keyVaultName, expectedCertificateName)
	assert.True(t, certificateName, "kv-cert does not exist")
}
