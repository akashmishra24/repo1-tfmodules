resource_group_name = "azngcpocnp-networking" # "<resource_group_name>"

recovery_services_vaults = {
  rsv1 = {
    name                = "vm-recovery-vault"        # <"recovery_services_vault_name">
    policy_name         = "vm-recovery-vault-policy" # <"vm_backup_policy_name">
    sku                 = "Standard"                 # <"Standard" | "RS0">
    soft_delete_enabled = false                      # <true | false>
    backup_settings = {
      frequency = "Daily" # <"Daily" | "Weekly">
      time      = "23:00" # <"24hour format">
      weekdays  = null    # <["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]>
    }
    retention_settings = {
      daily   = 10 # <1 to 9999>
      weekly  = "" # <"<1 to 9999>:<Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday>">
      monthly = "" # <"<1 to 9999>:<Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday>:<First,Second,Third,Fourth,Last>">
      yearly  = "" # <"<1 to 9999>:<Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday>:<First,Second,Third,Fourth,Last>:<January,February,March,April,May,June,July,Augest,September,October,November,December>">
    }
  }
}