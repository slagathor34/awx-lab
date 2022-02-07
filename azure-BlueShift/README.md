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

### Common

---
- [ ] Tasks that involve setup 
- [ ] Get KeyVault Values
- [ ] Set up packages for delivery

#### Resource Group

---
- [x] Created with 1 region
- [ ] Need to create based on tags

### Virtual Network

---
- [x] Sets up CIDR range
- [ ] Also sets up base for peering

### Subnets

---
- [x] Assigns subnets for each area
- [x] Creates initial NSG's for setup


### NSG

---
- [x] Creates and updates existing Network Security Groups


### Storage Account

---
- [x] Builds an Azure Storage Account
- [x] Sets the default access

### IaaS

---
- [ ] Lays down a Virtual Maachine inside of the Subnets
- [ ] Creates vNIC and public/private IP addresses
- [ ] Applys NSG


### PaaS

---
- [ ] Sets up platform in each subnet

### Services

---
- [ ] Load balancers
- [ ] Key Vaults
- [ ] Gateway API
- [ ] Application Gateways
- [ ] Site Recovery
- [ ] Observability, Monitoring, Metrics
- [ ] Middleware and Integration Platforms

### Application

---

### Closeout

---

## Used Variables

| Variable Name | Description | Example | Used In Role |
| :--- | :--- | :--- | :--- |
| rg_name | Resource Group Name | StormWatch | All roles |
| vnet_name | Name of the Virtual Network | StormvNet1 | VirtualNetwork, Subnets |
| App-name | Name of the Application | Spandex | Subnets |
| vnic_name | Name of the virtual NIC | Spandex-vnic | vNIC |
| storage_account_name | Name of the storage account | App-SA | StorageAccount |

## Manage IQ and Ansible Tower Configurations

### BlueShift Azure Standard Resource Group

![BlueShift Azure Resource Group](/img/BSC_RG_Framework.png)

### Ansible Tower

![Ansible Tower Role Orchestration With Tags](/img/Azure-BlueShift-Role-Orchestration-Tag-Tower.png)

![Ansible Tower Full Role](/img/Azure-BlueShift-Role-Tower.png)

![Ansible Tower Job Output](/img/Ansible-Tower-Job-Output.png)

![Azure BlueShift Role Orchestration Tag By Tower](/img/Azure-BlueShift-Role-Orchestration-Tag-Tower.png)

![](/img/Ansible-Tower-Job_submission-MIQ.png)

### Manage IQ

#### Ansible Tower Template Connected To Manage IQ
![](/img/ManageIQ-Ansible-Tower-Full-Role-Job-Template.png)

#### Manage IQ Service Catalog Item Configuration
![](/img/ManageIQ-Ansible-Tower-Service-Catalog-Item-BSFull-Edit-Config.png)

#### Manage IQ Service Catalog Full Screen Order
![](/img/ManageIQ-Ansible-Tower-Service-Catalog-Item-BSFull.png)

#### Manage IQ Service Catalog Item Screen Order Detailed
![](/img/ManageIQ-Ansible-Tower-Service-Catalog-Item-BSFull-Detail-Order.png)

#### Manage IQ Survey for Azure BlueShift Service Order
![](/img/ManageIQ-Ansible-Tower-Service-Catalog-Item-BSFull-Detail-Order-Survey.png)

#### Manage IQ Provisioned Service
![](/img/MIQ-Provisioned-Services.png)

#### Manage IQ - Available Resource For Service Addition And Tracking
![](/img/Azure-vnet-MIQ.png)

### Azure Output

#### Azure Resource Group Created
![](/img/Azure-provisioned-rg.png)

#### Azure Resource Group Details
![](/img/Azure-provisioned-rg-detailed.png)

## Todo

- [ ] Address service peering requirements
- [ ] Finish other base functions
- [ ] Start planning for Desired State Configuration