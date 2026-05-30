# IMS Infrastructure - Terraform

Terraform kod za deployment Inventory Management System aplikacije na AWS.

## Arhitektura

- **VPC** sa 2 public i 2 private subneta u us-east-1a i us-east-1b
- **Frontend** — React aplikacija na EC2 instancama u public subnetima iza ALB-a
- **Backend** — .NET aplikacija na EC2 instancama u private subnetima iza ALB-a
- **RDS** — PostgreSQL baza u private subnetima
- **S3** — bucket za statične fajlove (slike)
- **Auto Scaling Group** — automatsko skaliranje frontend i backend instanci
- **CloudWatch** — monitoring i logovanje

## Struktura

```
terraform-ims/
├── main.tf               # Provider konfiguracija
├── variables.tf          # Varijable
├── vpc.tf                # VPC, subneti, gatewayi
├── security.tf           # Security grupe
├── rds.tf                # PostgreSQL baza
├── alb.tf                # Load balanceri i target grupe
├── launch_templates.tf   # Launch templates za EC2
├── asg.tf                # Auto Scaling grupe i politike
├── s3.tf                 # S3 bucket za assets
├── outputs.tf            # Outputi
├── assets/               # Statični fajlovi za S3
│   ├── dccs.png
│   └── dccs.svg
└── scripts/
    ├── user_data_backend.sh
    └── user_data_frontend.sh
```

## Preduslovi

- [Terraform](https://developer.hashicorp.com/terraform/install) instaliran
- [AWS CLI](https://aws.amazon.com/cli/) instaliran
- AWS Academy sandbox sesija pokrenuta

## Konfiguracija kredencijala

Nakon pokretanja lab sesije na AWS Academy, u terminal ukucaj sljedecu komandu:

```bash
export AWS_ACCESS_KEY_ID="aws_access_key_id" 
export AWS_SECRET_ACCESS_KEY="aws_secret_acces_key" 
export AWS_SESSION_TOKEN="aws_session_token" 
```
Vrijednosti za sve ključeve se mogu naći u Workbench->Details->AWS CLI

Provjeri konekciju:

```bash
aws sts get-caller-identity
```

## Pokretanje

### 1. Inicijalizacija

```bash
terraform init
```

### 2. Pregled promjena

```bash
terraform plan
```

### 3. Deployment

```bash
terraform apply
```

### 4. S3 bucket problem 

Iako bi kod za kreiranje i upload asseta u S3 Bucket trebao raditi, Terraform izbacuje grešku do koje dolazi zbog ograničenja Sanboxa. Tako da je S3 bucket potrebno ručno kreirati i u njega uploadovati assete.


## Outputi

Nakon uspješnog `terraform apply` dobićeš:

| Output | Opis |
|--------|------|
| `frontend_alb_dns` | URL za pristup aplikaciji |
| `backend_alb_dns` | URL backend ALB-a |
| `rds_endpoint` | Endpoint baze podataka |


Aplikaciji pristupaš preko `frontend_alb_dns` linka.


## Uništavanje infrastrukture

```bash
terraform destroy
```
