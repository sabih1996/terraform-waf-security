# Terraform secure network firewall with CloudFront and AWS WAF

## Infrastructure Overview

This Terraform project builds a secure architecture for serving an application hosted on an EC2 instance in a private subnet using AWS CloudFront, Application Load Balancer (ALB), and Web Application Firewall (WAF) in order to secure it from cross site attacks, sql injections etc. The infrastructure uses modules for better organization and reusability. Each component (VPC, ALB, EC2, CloudFront, and WAF) is managed in its own module.

### Key Components:

1. **VPC and Subnets:**

- A Virtual Private Cloud (VPC) is created with one public and one private subnet.
- The public subnet is used for the ALB, while the private subnet is used for the EC2       instance hosting the application.

2. **EC2 Instance:**

- The EC2 instance resides in a private subnet, meaning it is not directly accessible from the internet.
- The instance is accessed through the ALB for secure traffic routing.

3. **ALB (Application Load Balancer):**

- An ALB in the public subnet is used to distribute HTTP/HTTPS traffic securely to the EC2 instance.
- ALB security group ensures that only HTTP (port 80) and HTTPS (port 443) traffic is allowed.
The ALB forwards traffic to the EC2 instance in the private subnet.

4. **CloudFront:**

- AWS CloudFront is used to cache content at edge locations for low-latency access.
- CloudFront serves as the public-facing endpoint and forwards requests to the ALB.
- CloudFront integrates with WAF for security rules (blocking unwanted traffic).

5. **WAF (Web Application Firewall):**

- AWS WAF is attached to the CloudFront distribution.
- The WAF blocks traffic from specific regions (e.g., China).
- Additional security measures include SQL injection prevention, cross-site scripting (XSS) detection, and rate limiting.
- A rate limit is set to block IPs making over 1000 requests in 5 minutes.

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

### Modules Breakdown

1. **VPC Module (modules/vpc/)**

- This module defines the networking layer with a VPC, public subnet, private subnet, route tables, and a Network ACL.
- The VPC enables isolated networking for the ALB and EC2 instance.
2. **ALB Module (modules/alb/)**
- This module creates the Application Load Balancer (ALB) to route traffic from the public internet to the EC2 instance.
- Security groups are attached to the ALB to allow HTTP and HTTPS traffic.
- An SSL certificate can be integrated to enable secure HTTPS traffic (currently, using CloudFront default certificate).

3. **EC2 Module (modules/ec2/)**
- The EC2 instance resides in the private subnet.
- Security groups only allow traffic from the ALB, making the instance unreachable from the internet directly.
- You can configure the instance type, AMI, and key pair in this module.
4. **CloudFront Module (modules/cloudfront/)**
- CloudFront acts as a global content delivery network (CDN) for low-latency access to the application.
- It is configured to use the ALB as the origin for requests.
- CloudFront allows edge caching and integrates with AWS WAF for enhanced security.
5. **WAF Module (modules/waf/)**
- The WAF module configures security rules to protect the application at the CloudFront layer.
***Key Rules:***
- Block traffic from China (geo_match_statement).
- Prevent SQL injection (sqli_match_statement).
- Detect and block Cross-Site Scripting (XSS) (xss_match_statement).
- Implement rate limiting to block IPs making over 1000 requests within a 5-minute period.

### How WAF Protects the Application

The Web Application Firewall (WAF) secures the application by filtering and blocking malicious traffic before it reaches the ALB or EC2 instance. Here are the key rules:

1. **Geo-blocking:** Blocks traffic from certain countries like China (configurable).

2. **SQL Injection Protection:** The WAF scans the request body for patterns that match SQL injection attempts and blocks them.

3. **XSS Protection:** The WAF detects and blocks cross-site scripting (XSS) attacks in the request body.

4. **Rate Limiting:** It blocks IP addresses that make too many requests in a short period (1000 requests in 5 minutes).

### How to Use This Project
1. **Install Terraform:** Ensure Terraform is installed on your machine.

2. **Set AWS Credentials:** Set up AWS credentials for Terraform to authenticate.

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
```
**Initialize Terraform:**
- Run `terraform init` to initialize the working directory.

**Validate the Infrastructure configurations:**
- Run `terraform validate` to validate infrastructure configurations.

**Plan the Infrastructure configurations:**
- Run `terraform plan` to plan the infrastructure configurations in order to check which resources are going to create and reconfirm the things.

**Apply the Infrastructure configurations:**

- Run `terraform apply` to create the infrastructure. Review the plan carefully, and type yes when prompted to apply changes.

Better to configure all these steps on terraform cloud add your secrects as variable and configure your git repo of infrastructure with T-Cloud in order to automate your infrastructure configurations rather than manually run these steps for production changes.

**Check Outputs:**

- After running terraform apply, you will see output values such as ALB DNS, CloudFront distribution URL, and VPC information.

**Access the Application:**

- Once the infrastructure is deployed, you can access the application via the CloudFront distribution URL.
- WAF will automatically filter out unwanted traffic based on the configured rules.

## Cost Improvement Suggestions:
1. **Right-size EC2 Instances:** Use auto-scaling and right-sizing to ensure you are not over-provisioning instances for your workload.
2. **Leverage Reserved Instances or Spot Instances:** Use Reserved Instances or Spot Instances to save significantly on EC2 instance costs.
3. **Optimize WAF Rules:** Simplify WAF rules to only those critical for your security needs to reduce the number of inspections.
4. **Cache More Content in CloudFront:**Optimize caching policies to reduce backend hits to your ALB and EC2, lowering the data transfer and compute costs.
5. **Monitor Costs with AWS Cost Explorer:** Use AWS Cost Explorer to regularly track and analyze where the costs are going, and make adjustments accordingly.
6. **Use Lambda or Fargate for Low-Traffic or Intermittent Workloads:**  Consider migrating smaller workloads to Lambda or Fargate if the traffic is variable or not continuous. This could eliminate the need for always-on EC2 instances.
7. **Turn Off Unused Resources:** Ensure that any non-production environments are turned off when not in use, like development or staging EC2 instances, to avoid unnecessary charges.
8. **Review Data Transfer Costs:** Minimize traffic between regions, and keep resources localized when possible. Reduce unnecessary egress traffic by using CloudFront and caching effectively.

### Conclusion
This project securely deploys an EC2-based application using an ALB for traffic routing and CloudFront for caching and DDoS protection. AWS WAF provides additional security by blocking malicious traffic and enforcing rate limits. The architecture is modular, making it easy to manage and extend for future requirements.