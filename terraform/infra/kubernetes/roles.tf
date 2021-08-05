resource "aws_iam_role" "external_dns_role" {
  name = "${var.stack_name}-${random_string.random.result}-${terraform.workspace}-dns-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_dns_role_doc.json
}

resource "aws_iam_policy" "external_dns_policy" {
  name = "${var.stack_name}-${random_string.random.result}-${terraform.workspace}-dns-policy"
  path        = "/"
  description = "allow eks pod change route53 records"

  policy = data.aws_iam_policy_document.external_dns_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
  role       = aws_iam_role.external_dns_role.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}

resource "aws_iam_role" "cluster_role" {
  name = "${var.stack_name}-${random_string.random.result}-${terraform.workspace}-cluster-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.cluster_role_doc.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role" "nodes_role" {
  name = "${var.stack_name}-${random_string.random.result}-${terraform.workspace}-nodes-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.node_role_doc.json
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_role.name
}


