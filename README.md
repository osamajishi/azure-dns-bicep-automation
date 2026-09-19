# Automated Azure Public DNS Zone & Round-Robin Resolution via Bicep

![Azure](https://img.shields.io/badge/Azure-0089D6?style=flat&logo=microsoft-azure&logoColor=white)
![IaC-Bicep](https://img.shields.io/badge/IaC-Bicep-blue?style=flat)
![Status](https://img.shields.io/badge/Deployment-Validated-brightgreen?style=flat)

## 1. Business Problem & Architecture Overview

### The Business Challenge
Manual DNS management via the Azure Portal presents major operational risks: configuration drift, zero change traceability, and human error during disaster recovery or multi-region failover. To guarantee deterministic deployments and auditability, authoritative domain hosting must be codified as Infrastructure-as-Code (IaC).

### Architecture Summary
* **Authoritative DNS Hosting**: Deploys an Azure Public DNS Zone on Microsoft’s Anycast network for low-latency, globally redundant resolution.
* **Round-Robin A-Records**: Maps a single host (`www`) across multiple target IPv4 endpoints (`1.2.3.4` and `1.2.3.5`) to distribute incoming traffic evenly at the DNS layer.
* **Root Apex Governance**: Relies on native Azure platform management for root `NS` and `SOA` records, preventing configuration overwrites.

```text
[Client / Resolver]
        │
        ▼
[Azure Anycast Name Servers (ns1-04.azure-dns.com)]
        │
        ├── A Record ──> 1.2.3.4 (Host A)
        └── A Record ──> 1.2.3.5 (Host B)
