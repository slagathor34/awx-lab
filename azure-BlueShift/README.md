# Azure BlueShift Role

## Role Workflow

```mermaid
flowchart LR
  subgraph Foundations
    Node0[Common] --> Node1[ResourceGroup]
    Node1[ResourceGroup] --> Node2[VirtualNetwork]
    Node2[VirtualNetwork] --> Node3[Subnets]
    Node3[Subnets] --> Node4[NSG]
    Node4[NSG] --> Node5[StorageAccount]
  end
  
  subgraph Services
    Node5[StorageAccount] --> Node6[IaaS]
    Node5[StorageAccount] --> Node7[PaaS]
    Node6[IaaS] --> Node8[Services]
    Node7[PaaS] --> Node8[Services]
  end
  
  subgraph Applications
    Node8[Services] --> Node9[Application]
    Node9[Application] --> Node10[Closeout]
  end
```

## Used Variables

| Variable Name | Description | Example | Used In Role |
| :--- | :--- | :--- | :--- |
| rg_name | Resource Group Name | StormWatch | All roles |
| vnet_name | Name of the Virtual Network | StormvNet1 | VirtualNetwork, Subnets |
| App-name | Name of the Application | Spandex | Subnets |
| vnic_name | Name of the virtual NIC | Spandex-vnic | vNIC |
| storage_account_name | Name of the storage account | App-SA | StorageAccount |

## Manage IQ and Ansible Tower Configurations

### Ansible Tower

![Ansible Tower Role Orchestration With Tags](/img/Azure-BlueShift-Role-Orchestration-Tag-Tower.png)
![Ansible Tower Full Role](/img/Azure-BlueShift-Role-Tower.png)
![](/img/Ansible-Tower-Job-Output.png)
![](/img/Azure-BlueShift-Role-Orchestration-Tag-Tower.png)
![](/img/Ansible-Tower-Job_submission-MIQ.png)

### Manage IQ

![](/img/ManageIQ-Ansible-Tower-Full-Role-Job-Template.png)
![](/img/ManageIQ-Ansible-Tower-Service-Catalog-Item-BSFull-Detail-Order-Survey.png)
![](/img/ManageIQ-Ansible-Tower-Service-Catalog-Item-BSFull-Detail-Order.png)
![](/img/ManageIQ-Ansible-Tower-Service-Catalog-Item-BSFull-Edit-Config.png)
![](/img/ManageIQ-Ansible-Tower-Service-Catalog-Item-BSFull.png)
![](/img/MIQ-Provisioned-Services.png)

### Azure Output

![](/img/Azure-provisioned-rg-detailed.png)
![](/img/Azure-provisioned-rg.png)
![](/img/Azure-vnet-MIQ.png)
![](/img/BSC Azure Cloud  - BSC Azure Resource Group Base framework.png)













## Todo

- [ ] Address service peering requirements
- [ ] Finish other base functions
- [ ] Start planning for Desired State Configuration