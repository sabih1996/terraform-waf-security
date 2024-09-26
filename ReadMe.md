## Terraform secure network firewall with AWS WAF

### Folder Structure

```graphql
├── main.tf
├── variables.tf
├── modules/
│   ├── vpc/
│   │   ├── vpc.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── alb/
│   │   ├── alb.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── ec2/
│   │   ├── ec2.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── cloudfront/
│   │   ├── cloudfront.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── waf/            # NEW WAF module
│   │   ├── waf.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
```