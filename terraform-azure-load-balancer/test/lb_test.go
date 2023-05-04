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
	//keyVaultName := GenOutput("key_vault_name")
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	expectedLBPublicName := terraform.Output(t, terraformOptions, "lb_public_name")
	expectedLBPrivateName := terraform.Output(t, terraformOptions, "lb_private_name")
	expectedLBNoFEConfigName := terraform.Output(t, terraformOptions, "lb_default_name")
	expectedLBPublicFeConfigName := terraform.Output(t, terraformOptions, "lb_public_fe_config_name")
	expectedLBPrivateFeConfigName := terraform.Output(t, terraformOptions, "lb_private_fe_config_static_name")
	expectedLBPrivateIP := terraform.Output(t, terraformOptions, "lb_private_ip_static")

	//assert.Equal(t, "kv-test-eastus-non-prod", keyVaultName)
	actualLBDoesNotExist := azure.LoadBalancerExists(t, "negative-test", resourceGroupName, subscriptionID)
	assert.False(t, actualLBDoesNotExist)

	t.Run("LoadBalancer_Public", func(t *testing.T) {
		// Check Public Load Balancer exists.
		actualLBPublicExists := azure.LoadBalancerExists(t, expectedLBPublicName, resourceGroupName, subscriptionID)
		assert.True(t, actualLBPublicExists)

		// Check Frontend Configuration for Load Balancer.
		actualLBPublicFeConfigNames := azure.GetLoadBalancerFrontendIPConfigNames(t, expectedLBPublicName, resourceGroupName, subscriptionID)
		assert.Contains(t, actualLBPublicFeConfigNames, expectedLBPublicFeConfigName)

		// Check Frontend Configuration Public Address and Public IP assignment
		actualLBPublicIPAddress, actualLBPublicIPType := azure.GetIPOfLoadBalancerFrontendIPConfig(t, expectedLBPublicFeConfigName, expectedLBPublicName, resourceGroupName, subscriptionID)
		assert.NotEmpty(t, actualLBPublicIPAddress)
		assert.Equal(t, azure.PublicIP, actualLBPublicIPType)
	})

	t.Run("LoadBalancer_Private", func(t *testing.T) {
		// Check Private Load Balancer exists.
		actualLBPrivateExists := azure.LoadBalancerExists(t, expectedLBPrivateName, resourceGroupName, subscriptionID)
		assert.True(t, actualLBPrivateExists)

		// Check Frontend Configuration for Load Balancer.
		actualLBPrivateFeConfigNames := azure.GetLoadBalancerFrontendIPConfigNames(t, expectedLBPrivateName, resourceGroupName, subscriptionID)
		assert.Equal(t, 2, len(actualLBPrivateFeConfigNames))
		assert.Contains(t, actualLBPrivateFeConfigNames, expectedLBPrivateFeConfigName)

		// Check Frontend Configuration Private IP Type and Address.
		actualLBPrivateIPAddress, actualLBPrivateIPType := azure.GetIPOfLoadBalancerFrontendIPConfig(t, expectedLBPrivateFeConfigName, expectedLBPrivateName, resourceGroupName, subscriptionID)
		assert.NotEmpty(t, actualLBPrivateIPAddress)
		assert.Equal(t, expectedLBPrivateIP, actualLBPrivateIPAddress)
		assert.Equal(t, azure.PrivateIP, actualLBPrivateIPType)
	})

	t.Run("LoadBalancer_Default", func(t *testing.T) {
		// Check No Frontend Config Load Balancer exists.
		actualLBNoFEConfigExists := azure.LoadBalancerExists(t, expectedLBNoFEConfigName, resourceGroupName, subscriptionID)
		assert.True(t, actualLBNoFEConfigExists)

		// Check for No Frontend Configuration for Load Balancer.
		actualLBNoFEConfigFeConfigNames := azure.GetLoadBalancerFrontendIPConfigNames(t, expectedLBNoFEConfigName, resourceGroupName, subscriptionID)
		assert.Equal(t, 0, len(actualLBNoFEConfigFeConfigNames))
	})
}
