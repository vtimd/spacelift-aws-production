# Spacelift Terraform: EC2 + S3 (Basic)

This example provisions:
- One S3 bucket (private, with public access blocked)
- One Amazon Linux 2 EC2 instance with a simple HTTP server

## How to use in Spacelift

1. **Push this folder to a Git repo** (or a subdirectory of an existing repo).
2. In **Spacelift**, create a **Stack**:
   - **VCS repo**: point to this repo/folder.
   - **Runner**: default is fine.
   - **State**: leave backend out—Spacelift manages state automatically.
3. **AWS integration**:
   - In the Stack settings → **Integrations → AWS**, enable **Assume Role** and select the role your platform team set up.
4. **Inputs / Environment**:
   - Optionally set:
     - `TF_VAR_region` (default `us-east-1`)
     - `TF_VAR_project` (default `spacelift-demo`)
     - `TF_VAR_instance_type` (default `t3.micro`)
     - `TF_VAR_ec2_key_name` if you want SSH access
5. **Run**:
   - Open a PR or trigger a run. Approve the **Plan** and **Apply**.

## Notes
- The S3 bucket name must be globally unique. We add a random suffix automatically.
- Security group is wide open for demo (`0.0.0.0/0` for SSH and HTTP). Tighten this for production.
- Using the **default VPC** and a **default subnet** keeps the example simple—adapt to your networking standards.
