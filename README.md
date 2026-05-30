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

Nakon pokretanja lab sesije na AWS Academy, kopiraj kredencijale u `~/.aws/credentials`:

```bash
cat > ~/.aws/credentials << 'EOF'
[default]
aws_access_key_id=ТВОЈ_KEY
aws_secret_access_key=ТВОЈ_SECRET
aws_session_token=ТВОЈ_TOKEN
EOF
```

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

### 4. S3 bucket (ako dođe do greške sa Object Lock)

Ako `terraform apply` baci grešku za S3 bucket, importuj ga i ponovi:

```bash
terraform state rm aws_s3_bucket.assets
terraform import aws_s3_bucket.assets <bucket-naziv>
terraform apply
```

## Outputi

Nakon uspješnog `terraform apply` dobićeš:

| Output | Opis |
|--------|------|
| `frontend_alb_dns` | URL za pristup aplikaciji |
| `backend_alb_dns` | URL backend ALB-a |
| `rds_endpoint` | Endpoint baze podataka |
| `s3_bucket_url` | URL S3 bucketa |

Aplikaciji pristupaš preko `frontend_alb_dns` linka.

## Promjena konfiguracije

Sve varijable se nalaze u `variables.tf`:

| Varijabla | Opis |
|-----------|------|
| `db_host` | RDS endpoint |
| `db_name` | Naziv baze |
| `db_username` | Korisničko ime za bazu |
| `db_password` | Lozinka za bazu |
| `backend_url` | Backend ALB DNS za frontend |
| `s3_url` | S3 bucket URL |

## Uništavanje infrastrukture

```bash
terraform destroy
```

## Napomene

- AWS Academy sandbox kredencijali istječu kada sesija završi — moraš ih osvježiti pri svakom pokretanju
- Docker build na EC2 instancama traje 10-15 minuta — instance postaju healthy nakon toga
- `terraform.tfstate` fajl nije u git repozitoriju — čuvaj ga lokalno