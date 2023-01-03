package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

var (
	globalEnvVars = make(map[string]string)
)


func setTerraformVariables() (map[string]string, error) {

	// Getting enVars from environment variables
	ARM_CLIENT_ID := os.Getenv("AZURE_CLIENT_ID")
	ARM_CLIENT_SECRET := os.Getenv("AZURE_CLIENT_SECRET")
	ARM_TENANT_ID := os.Getenv("AZURE_TENANT_ID")
	ARM_SUBSCRIPTION_ID := os.Getenv("AZURE_SUBSCRIPTION_ID")

	// Creating globalEnVars for terraform call through Terratest
	if ARM_CLIENT_ID != "" {
		globalEnvVars["ARM_CLIENT_ID"] = ARM_CLIENT_ID
		globalEnvVars["ARM_CLIENT_SECRET"] = ARM_CLIENT_SECRET
		globalEnvVars["ARM_SUBSCRIPTION_ID"] = ARM_SUBSCRIPTION_ID
		globalEnvVars["ARM_TENANT_ID"] = ARM_TENANT_ID
	}

	return globalEnvVars, nil
}

func TestTerraformStorageAcct(t *testing.T) {
	setTerraformVariables()
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "./",
		VarFiles:     []string{"terratest_input.tfvars"},
		// globalvariables for user account
		EnvVars: globalEnvVars,
	})
	
	// GenOutput generates the output string to be asserted against
	GenOutput := func(outputName string) (generated string) {
		generated = terraform.Output(t, terraformOptions, outputName)
		return
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	resourceGroup := GenOutput("resource_group")
	storageAcctNames := GenOutput("sa_names")
	containerNames := GenOutput("container_names")
	storageHttpsTraffic := GenOutput("sa_https_traffic")
	storageTLS := GenOutput("sa_tls_version")
	storageAccessTier := GenOutput("sa_access_tier")
	storageAccountKind := GenOutput("sa_account_kind")
	storageReplicationType := GenOutput("sa_account_replication_type")
	storageAccountTier := GenOutput("sa_account_tier")

	assert.Equal(t, "[atstftststorageacct]", storageAcctNames)
	assert.Equal(t, "[tf-strg-acct-testing]", resourceGroup)
	assert.Equal(t, "[tftststoragecontainer]", containerNames)
	assert.Equal(t,"map[atstftststorageacct:true]", storageHttpsTraffic)
	assert.Equal(t,"map[atstftststorageacct:TLS1_2]", storageTLS)
	assert.Equal(t,"map[atstftststorageacct:Hot]", storageAccessTier)
	assert.Equal(t,"map[atstftststorageacct:StorageV2]", storageAccountKind)
	assert.Equal(t,"map[atstftststorageacct:LRS]", storageReplicationType)
	assert.Equal(t,"map[atstftststorageacct:Standard]", storageAccountTier)
}
