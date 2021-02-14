# cluster
resource "aws_eks_cluster" "this" {
    name     = "example_clister"
    role_arn = aws_iam_role.eks-cluster.arn

    vpc_config {
        endpoint_private_access = true
        security_group_ids = [aws_security_group.this.id]
        subnet_ids = [
            aws_subnet.public01.id,
            aws_subnet.public02.id,
            aws_subnet.private01.id,
            aws_subnet.private02.id
        ]
    }

    depends_on = [
        aws_iam_role_policy_attachment.this-AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.this-AmazonEKSVPCResourceController,
    ]
}

# node_group
resource "aws_eks_node_group" "this" {
    cluster_name    = aws_eks_cluster.this.name
    node_group_name = "example_node"
    node_role_arn   = aws_iam_role.eks-node-group.arn
    subnet_ids = [
        aws_subnet.public01.id,
        aws_subnet.public02.id,
        aws_subnet.private01.id,
        aws_subnet.private02.id
    ]

    scaling_config {
        desired_size = 1
        max_size     = 1
        min_size     = 1
    }

    depends_on = [
        aws_iam_role_policy_attachment.this-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.this-AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.this-AmazonEC2ContainerRegistryReadOnly,
    ]
}