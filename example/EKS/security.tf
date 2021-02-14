resource "aws_security_group" "this" {
    name        = "eks-vpc-ControlPlaneSecurityGroup"
    description = "Cluster communication with worker nodes"
    vpc_id      = aws_vpc.this.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "eks-ControlPlane_example"
    }
}