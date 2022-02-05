# Azure BlueShift Role

## Role Workflow

```mermaid
graph TB
  subgraph "Azure Foundational Role"
  Node1[ResourceGroup] --> Node2[VirtualNetwork]
  Node2[VirtualNetwork] --> Node3[Subnets]
  Node3[Subnets] --> Node4[NSG]
  Node4[NSG] --> Node5[StorageAccount]
  Node5[StorageAccount] --> Node6[IaaS]
  Node6[IaaS] --> Node7[vNIC]
  Node7[vNIC] --> Node8[Services]
end
```

## Used Variables

| Variable Name | Description | Example | Used In Role |
| :--- | :--- | :--- | :--- |
| rgname | Resource Group Name | StormWatch | All roles |
| vnet_name | Name of the Virtual Network | StormvNet1 | VirtualNetwork, Subnets |
| App-name | Name of the Application | Spandex | Subnets |
| vnic_name | Name of the virtual NIC | 

## Todo

- [ ] Address service peering requirements
- [ ] Finish other base functions
- [ ] Start planning for Desired State Configuration