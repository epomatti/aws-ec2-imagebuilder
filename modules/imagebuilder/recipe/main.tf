resource "aws_imagebuilder_image_recipe" "default" {
  name         = "TailscaleUbuntu22"
  description  = "Updated Tailscale image with all features enabled + SSM Agent + CloudWatch Agent"
  parent_image = var.ubunt22arm_parent_image
  version      = "1.0.0"

  systems_manager_agent {
    uninstall_after_build = false
  }

  # Build
  component {
    component_arn = "arn:aws:imagebuilder:${var.aws_region}:aws:component/update-linux/x.x.x"
  }

  component {
    component_arn = "arn:aws:imagebuilder:${var.aws_region}:aws:component/reboot-linux/x.x.x"
  }

  component {
    component_arn = "arn:aws:imagebuilder:${var.aws_region}:aws:component/amazon-cloudwatch-agent-linux/x.x.x"
  }

  component {
    component_arn = var.tailscale_build_component_arn
  }  

  # Test
  component {
    component_arn = var.tailscale_test_component_arn
  }


  block_device_mapping {
    device_name = "/dev/sda1"

    ebs {
      encrypted             = true
      volume_size           = 8
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }
}
