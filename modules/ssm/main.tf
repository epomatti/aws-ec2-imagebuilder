resource "aws_ssm_parameter" "cloudwath_config_file" {
  name  = "AmazonCloudWatch-linux-TailscaleImageBuilderTest"
  type  = "String"
  value = file("${path.module}/config.json")
}
