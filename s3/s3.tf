resource "aws_s3_bucket" "config_files_s3" {
  bucket        = "${var.S3_Bucket_Name}"
  acl           = "${var.core_acl}"
  versioning {
    enabled = "true"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "aws_s3_bucket_policy" "config_files_s3bucket_policy" {
  bucket     = "${var.S3_Bucket_Name}"
  policy = "${var.s3_bucket_policy}"
#  policy = <<POLICY
#{
#  "Id": "Policy1550741998414",
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "Stmt1550741996351",
#      "Action": [
#       "s3:GetObject",
#        "s3:GetObjectTagging",
#        "s3:PutObject",
#        "s3:PutObjectAcl",
#        "s3:PutObjectTagging"
#      ],
#      "Effect": "Allow",
#      "Resource": "arn:aws:s3:::uki-avaya-config-files/*",
#      "Principal": {
#        "AWS": [
#          "arn:aws:iam::320132909094:role/test_Lambda"
#        ]
#      }
#    }
#  ]
#}
#POLICY
  depends_on = ["aws_s3_bucket.config_files_s3"]

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

resource "aws_s3_bucket_public_access_block" "core_s3_bucket_publicAccess" {
  bucket                  = "${var.S3_Bucket_Name}"
 block_public_acls       = "${var.block_bucket_public_acls}"
  block_public_policy     = "${var.block_bucket_public_policy}"
  ignore_public_acls      = "${var.ignore_public_acls}"
  restrict_public_buckets = "${var.restrict_public_buckets}"
  depends_on              = ["aws_s3_bucket_policy.config_files_s3bucket_policy"]

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

