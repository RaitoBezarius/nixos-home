let
  thors = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcEkYM1r8QVNM/G5CxJInEdoBCWjEHHDdHlzDYNSUIdHHsn04QY+XI67AdMCm8w30GZnLUIj5RiJEWXREUApby0GrfxGGcy8otforygfgtmuUKAUEHdU2MMwrQI7RtTZ8oQ0USRGuqvmegxz3l5caVU7qGvBllJ4NUHXrkZSja2/51vq80RF4MKkDGiz7xUTixI2UcBwQBCA/kQedKV9G28EH+1XfvePqmMivZjl+7VyHsgUVj9eRGA1XWFw59UPZG8a7VkxO/Eb3K9NF297HUAcFMcbY6cPFi9AaBgu3VC4eetDnoN/+xT1owiHi7BReQhGAy/6cdf7C/my5ehZwD raito@RaitoBezarius-Laptop-OverDrive";
  laptops = [ thors ];
in
{
  "gotifyToken.age".publicKeys = laptops;
  "rzDroneToken.age".publicKeys = laptops;
}
