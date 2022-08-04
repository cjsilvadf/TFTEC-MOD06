resource "azurerm_monitor_action_group" "Monitor" {
  name                = "Monitor"
  resource_group_name = azurerm_resource_group.ResGroup.name
  short_name          = "Monitor"
}

resource "azurerm_consumption_budget_resource_group" "BudGetRG" {
  name              = "BudGestRG-AZ-104"
  resource_group_id = azurerm_resource_group.ResGroup.id

  amount     = 1000
  time_grain = "Monthly"

  time_period {
    start_date = "2022-08-01T00:00:00Z"
    end_date   = "2022-08-31T00:00:00Z"
  }

  filter {
    dimension {
      name = "ResourceId"
      values = [
        azurerm_monitor_action_group.Monitor.id,
      ]
    }

    tag {
      name = "foo"
      values = [
        "bar",
        "baz",
      ]
    }
  }

  notification {
    enabled        = true
    threshold      = 90.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_emails = [
      "cleiton@cleitonjose.eti.br",
      "cleitonjosedf@gmail.com",
    ]

    contact_groups = [
      azurerm_monitor_action_group.Monitor.id,
    ]

    contact_roles = [
      "Owner",
    ]
  }
}