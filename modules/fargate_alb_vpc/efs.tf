resource "aws_efs_file_system" "service" {
  creation_token  = "${terraform.workspace}-${var.service}-service-fileystem"
  tags            = var.tags
}

resource "aws_efs_mount_target" "service-mount-efs1" {
  file_system_id  = aws_efs_file_system.service.id
  subnet_id       = var.vpc_private_subnet_ids[0]
  security_groups = [aws_security_group.sg_efs_filesystem.id]
}

resource "aws_efs_mount_target" "service-mount-efs2" {
  file_system_id  = aws_efs_file_system.service.id
  subnet_id       = var.vpc_private_subnet_ids[1]
  security_groups = [aws_security_group.sg_efs_filesystem.id]
}

resource "aws_efs_mount_target" "service-mount-efs3" {
  file_system_id  = aws_efs_file_system.service.id
  subnet_id       = var.vpc_private_subnet_ids[2]
  security_groups = [aws_security_group.sg_efs_filesystem.id]
}
