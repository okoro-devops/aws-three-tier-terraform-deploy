# ==========================
# Elastic IPs for NAT
# ==========================
resource "aws_eip" "nat" {
  count = var.countsub

  tags = {
    Name        = "${var.environment}-elastic-ip-nat-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.gw]
}