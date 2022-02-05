## Role Workflow
```mermaid
graph TB

  subgraph "Azure Foundational Role"
  Node1[ResourceGroup] --> Node2[VirtualNetwork]
  Node2[VirtualNetwork] --> Node3[Subnets]
  Node3[Subnets] --> Node4[NSG]
end
```

## Used Variables 
| Variable Name | Description | Example | Used In Role |
| :--- | :--- | :--- | :--- |
| rgname | Resource Group Name | StormWatch | All roles |
| vnet_name | Name of the Virtual Network | StormvNet1 | VirtualNetwork, Subnets |
| App-name | Name of the Application | Spandex | Subnets |

