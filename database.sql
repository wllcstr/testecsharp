USE [master]
GO
CREATE DATABASE [cadfornecedores]
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [cadfornecedores].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [cadfornecedores] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [cadfornecedores] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [cadfornecedores] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [cadfornecedores] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [cadfornecedores] SET ARITHABORT OFF 
GO
ALTER DATABASE [cadfornecedores] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [cadfornecedores] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [cadfornecedores] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [cadfornecedores] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [cadfornecedores] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [cadfornecedores] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [cadfornecedores] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [cadfornecedores] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [cadfornecedores] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [cadfornecedores] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [cadfornecedores] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [cadfornecedores] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [cadfornecedores] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [cadfornecedores] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [cadfornecedores] SET  MULTI_USER 
GO
ALTER DATABASE [cadfornecedores] SET DB_CHAINING OFF 
GO
ALTER DATABASE [cadfornecedores] SET ENCRYPTION ON
GO
ALTER DATABASE [cadfornecedores] SET QUERY_STORE = ON
GO
ALTER DATABASE [cadfornecedores] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [cadfornecedores]
GO
/****** Object:  Table [dbo].[empresas]    Script Date: 28/01/2020 00:36:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[empresas](
	[emp_id] [int] IDENTITY(1,1) NOT NULL,
	[emp_fantasia] [varchar](256) NOT NULL,
	[emp_uf] [varchar](2) NOT NULL,
	[emp_cnpj] [varchar](14) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fornecedores]    Script Date: 28/01/2020 00:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fornecedores](
	[for_id] [int] IDENTITY(1,1) NOT NULL,
	[for_nome] [varchar](256) NOT NULL,
	[for_dtcad] [datetime] NOT NULL,
	[for_dtnas] [date] NULL,
	[for_doc] [varchar](14) NOT NULL,
	[for_rg] [nchar](10) NULL,
	[for_empre] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[for_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[telefonesf]    Script Date: 28/01/2020 00:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[telefonesf](
	[tel_id] [int] IDENTITY(1,1) NOT NULL,
	[tel_fone] [varchar](20) NOT NULL,
	[tel_contato] [varchar](256) NULL,
	[tel_fid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[fornecedores]  WITH CHECK ADD FOREIGN KEY([for_empre])
REFERENCES [dbo].[empresas] ([emp_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[telefonesf]  WITH CHECK ADD FOREIGN KEY([tel_fid])
REFERENCES [dbo].[fornecedores] ([for_id])
ON DELETE CASCADE
GO
USE [master]
GO
ALTER DATABASE [cadfornecedores] SET  READ_WRITE 
GO
