resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "${local.app_name}-${local.env}"
  }
}

# TODO:ループする
resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.0.0/28"

  tags = {
    Name = "${local.app_name}-${local.env}-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.0.16/28"

  tags = {
    Name = "${local.app_name}-${local.env}-public-1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1d"
  cidr_block        = "10.0.0.32/28"

  tags = {
    Name = "${local.app_name}-${local.env}-public-1d"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.0.128/28"

  tags = {
    Name = "${local.app_name}-${local.env}-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.0.144/28"

  tags = {
    Name = "${local.app_name}-${local.env}-private-1c"
  }
}

resource "aws_subnet" "private_1d" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1d"
  cidr_block        = "10.0.0.160/28"

  tags = {
    Name = "${local.app_name}-${local.env}-private-1d"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.app_name}-${local.env}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.app_name}-${local.env}-public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
}

# TODO:ループする
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1d" {
  subnet_id      = aws_subnet.public_1d.id
  route_table_id = aws_route_table.public.id
}
