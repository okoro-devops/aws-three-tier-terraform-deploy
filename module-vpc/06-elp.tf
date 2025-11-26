# ==========================
# Elastic IPs for NAT
# ==========================
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.environment}-nat-eip"
  }
}

