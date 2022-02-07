# Azure BlueShift Role

This role is used to create a standardized resource group inside of the Azure Landing Zone of target. Two files exist to control this role: 

- azure-blueshift-role.yml - Create the entire standard Azure BlueShift Resource Group. 

- azure-blueshift-orchestration.yml - Created to trigger instances of the role without running through all roles using tags. 

Example tag execution: 


ansible-playbook azure-blueshift-orchestration.yml --tags CreateRG

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

Orchestration Tag: **Common**

- [ ] Tasks that involve setup
- [ ] Get KeyVault Values
- [ ] Set up packages for delivery

#### Resource Group

---

Orchestration Tag: **CreateRG**

- [x] Created with 1 region
- [ ] Need to create based on tags

### Virtual Network

---

Orchestration Tag: **CreateVnet**

- [x] Sets up CIDR range
- [ ] Also sets up base for peering

### Subnets

---

Orchestration Tag: **CreateSubnets**

- [x] Assigns subnets for each area
- [x] Creates initial NSG's for setup


### NSG

---

Orchestration Tag: **CreateNSG**

- [x] Creates and updates existing Network Security Groups


### Storage Account

---

Orchestration Tag: **CreateStorageAccount**

- [x] Builds an Azure Storage Account
- [x] Sets the default access
- [ ] Set up private endpoint 
- [ ] Set up threst protection

### IaaS

---

Orchestration Tag: **CreateIaaS**

- [ ] Lays down a Virtual Maachine inside of the Subnets
- [ ] Creates vNIC and public/private IP addresses
- [ ] Install required extensions
- [ ] Constrain with Desired State
- [ ] Applys NSG


### PaaS

---

Orchestration Tag: **CreatePaaS**

- [ ] Sets up platform in each subnet
- [ ] Collect all REST API's for handoff to Shared Services
- [ ] Plumb Ingress points to gateways and Load Balancers
- [ ] Configure NAT for WAF connection

### Services

---

Orchestration Tag: **CreateServices**

- [ ] Load balancers
- [ ] Key Vaults
- [ ] Gateway API
- [ ] Application Gateways
- [ ] Site Recovery
- [ ] Observability, Monitoring, Metrics
- [ ] Middleware and Integration Platforms

### Application

---

Orchestration Tag: **CreateApplication**

- [ ] Get code from Repository
- [ ] Install in correct location
- [ ] Set up application to start correctly
- [ ] Ensure all tools are installed and ready for production release

### Closeout

---

Orchestration Tag: **Closeout**

- [ ] Test release
- [ ] Report on performance
- [ ] Update ServiceNow/CMDB

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

#### Ansible Tower Role Orchestration Execution Using Tags

![Ansible Tower Role Orchestration With Tags](/img/Azure-BlueShift-Role-Orchestration-Tag-Tower.png)

#### Ansible Tower Full Azure BlueShift Role

![Ansible Tower Full Role](/img/Azure-BlueShift-Role-Tower.png)

#### Ansible Tower Full Role Job Output

![Ansible Tower Job Output](/img/Ansible-Tower-Job-Output.png)

#### Ansible Tower Job Submission from Manage IQ

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