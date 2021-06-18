USE [master]
GO
/****** Object:  Database [SistemaObrero]    Script Date: 18/06/2021 10:48:42 ******/
CREATE DATABASE [SistemaObrero]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SistemaObrero', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SistemaObrero.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SistemaObrero_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\SistemaObrero_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [SistemaObrero] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SistemaObrero].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SistemaObrero] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SistemaObrero] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SistemaObrero] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SistemaObrero] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SistemaObrero] SET ARITHABORT OFF 
GO
ALTER DATABASE [SistemaObrero] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SistemaObrero] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SistemaObrero] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SistemaObrero] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SistemaObrero] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SistemaObrero] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SistemaObrero] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SistemaObrero] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SistemaObrero] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SistemaObrero] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SistemaObrero] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SistemaObrero] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SistemaObrero] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SistemaObrero] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SistemaObrero] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SistemaObrero] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SistemaObrero] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SistemaObrero] SET RECOVERY FULL 
GO
ALTER DATABASE [SistemaObrero] SET  MULTI_USER 
GO
ALTER DATABASE [SistemaObrero] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SistemaObrero] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SistemaObrero] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SistemaObrero] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SistemaObrero] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SistemaObrero] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'SistemaObrero', N'ON'
GO
ALTER DATABASE [SistemaObrero] SET QUERY_STORE = OFF
GO
USE [SistemaObrero]
GO
/****** Object:  UserDefinedFunction [dbo].[CargarXML]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CargarXML]( )
	RETURNS XML

	BEGIN
		DECLARE @docXML XML = (
		SELECT * FROM(
			SELECT CAST(c AS XML) FROM
			OPENROWSET(
				BULK 'C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL\Datos_Tarea3.xml',SINGLE_BLOB) AS T(c)
			) AS S(C)
		)
		
		RETURN @docXML;
	END

/*
Path del archivo XML
C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\III-Proyecto-Bases\SQL\Datos_Tarea3.xml
C:\Users\luist\OneDrive\Escritorio\Proyecto 3\III-Proyecto-Bases\SQL\Datos_Tarea3.xml
*/
GO
/****** Object:  Table [dbo].[BitacoraErrores]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BitacoraErrores](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Error] [varchar](100) NOT NULL,
 CONSTRAINT [PK_BitacoraErrores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Corrida]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Corrida](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaOperacion] [date] NOT NULL,
	[TipoRegistro] [int] NOT NULL,
	[PostTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Corrida] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeduccionPorcentualObligatoria]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionPorcentualObligatoria](
	[Id] [int] NOT NULL,
	[Porcentage] [float] NOT NULL,
 CONSTRAINT [PK_DeduccionPorcentualObligatoria] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeduccionXEmpleado]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionXEmpleado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NULL,
	[FechaFin] [date] NULL,
	[IdEmpleado] [int] NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
 CONSTRAINT [PK_DeduccionXEmpleado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeduccionXEmpleadoNoObligatoriaPorcentual]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionXEmpleadoNoObligatoriaPorcentual](
	[Id] [int] NOT NULL,
	[Porcentage] [float] NOT NULL,
 CONSTRAINT [PK_DeduccionXEmpleadoNoObligatoriaPorcentual] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeduccionXEmpleadoXMes]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionXEmpleadoXMes](
	[Id] [int] NOT NULL,
	[TotalDeduccion] [int] NOT NULL,
	[IdPlanillaXMesXEmpleado] [int] NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
 CONSTRAINT [PK_DeduccionXEmpleadoXMes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departamento]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departamento](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Departamento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleCorrida]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCorrida](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCorrida] [int] NOT NULL,
	[TipoOperacionXML] [int] NOT NULL,
	[Secuencia] [int] NOT NULL,
 CONSTRAINT [PK_DetalleCorrida] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleados]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleados](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[ValorDocumentoIdentidad] [int] NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[IdPuesto] [int] NOT NULL,
	[IdDepartamento] [int] NOT NULL,
	[IdTipoDocumentoIdentidad] [int] NOT NULL,
	[NombreUsuario] [varchar](64) NOT NULL,
	[Contraseña] [varchar](64) NOT NULL,
	[Tipo] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Empleados] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Errores]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Errores](
	[SUSER_SNAME] [varchar](max) NULL,
	[ERROR_NUMBER] [int] NULL,
	[ERROR_STATE] [int] NULL,
	[ERROR_SEVERITY] [int] NULL,
	[ERROR_LINE] [int] NULL,
	[ERROR_PROCEDURE] [varchar](max) NULL,
	[ERROR_MESSAGE] [varchar](max) NULL,
	[GETDATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feriados]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feriados](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[Fecha] [date] NOT NULL,
 CONSTRAINT [PK_Feriados] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FijaNoObligatoria]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FijaNoObligatoria](
	[Id] [int] NOT NULL,
	[Monto] [float] NOT NULL,
 CONSTRAINT [PK_FijaNoObligatoria] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Jornada]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jornada](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoJornada] [int] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[IdSemanaPlanilla] [int] NULL,
 CONSTRAINT [PK_Jornada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MarcaDeAsistencia]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcaDeAsistencia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaEntrada] [smalldatetime] NOT NULL,
	[FechaSalida] [smalldatetime] NOT NULL,
	[IdJornada] [int] NOT NULL,
 CONSTRAINT [PK_MarcaDeAsistencia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MesPlanilla]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MesPlanilla](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaIncio] [date] NOT NULL,
	[FechaFinal] [date] NOT NULL,
 CONSTRAINT [PK_MesPlanilla] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoDeduccion]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoDeduccion](
	[Id] [int] NOT NULL,
	[IdDeduccionXEmpleado] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoDeduccion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoDeHoras]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoDeHoras](
	[Id] [int] NOT NULL,
	[IdMarcaAsistencia] [int] NOT NULL,
	[HorasOrdinarias] [int] NOT NULL,
	[HorasExtra] [int] NOT NULL,
	[HorasExtraDoble] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoDeHoras] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoPlanilla]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoPlanilla](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [float] NOT NULL,
	[IdTipoMovimientoPlanilla] [int] NOT NULL,
	[IdPlanillaXSemanaXEmpleado] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoPlanilla] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanillaXMesxEmpleado]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanillaXMesxEmpleado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SalarioBruto] [float] NOT NULL,
	[SalarioNeto] [float] NOT NULL,
	[IdMesPlanilla] [int] NOT NULL,
 CONSTRAINT [PK_PlanillaXMesxEmpleado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanillaXSemanaxEmpleado]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanillaXSemanaxEmpleado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SalarioBruto] [float] NOT NULL,
	[SalarioNeto] [float] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[IdSemanaPlanilla] [int] NOT NULL,
	[IdPlanillaXMesXEmpleado] [int] NOT NULL,
 CONSTRAINT [PK_PlanillaXSemanaxEmpleado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Puestos]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puestos](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](40) NOT NULL,
	[SalarioXHora] [float] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Puestos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SemanaPlanilla]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SemanaPlanilla](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFinal] [date] NOT NULL,
	[IdMesPlanilla] [int] NOT NULL,
 CONSTRAINT [PK_SemanaPlanilla_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDeduccion]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDeduccion](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[EsObligatoria] [varchar](64) NOT NULL,
	[EsPorcentual] [varchar](64) NOT NULL,
 CONSTRAINT [PK_TipoDeduccion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDocIdentidad]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDocIdentidad](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoDocIdentidad] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoJornada]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoJornada](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](64) NOT NULL,
	[HoraInicio] [time](7) NOT NULL,
	[HoraFin] [time](7) NOT NULL,
 CONSTRAINT [PK_TipoJornada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoPlanilla]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoPlanilla](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoMovimientoPlanilla] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeduccionPorcentualObligatoria]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionPorcentualObligatoria_TipoDeduccion] FOREIGN KEY([Id])
REFERENCES [dbo].[TipoDeduccion] ([Id])
GO
ALTER TABLE [dbo].[DeduccionPorcentualObligatoria] CHECK CONSTRAINT [FK_DeduccionPorcentualObligatoria_TipoDeduccion]
GO
ALTER TABLE [dbo].[DeduccionXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleado_Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleados] ([Id])
GO
ALTER TABLE [dbo].[DeduccionXEmpleado] CHECK CONSTRAINT [FK_DeduccionXEmpleado_Empleados]
GO
ALTER TABLE [dbo].[DeduccionXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleado_TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([Id])
GO
ALTER TABLE [dbo].[DeduccionXEmpleado] CHECK CONSTRAINT [FK_DeduccionXEmpleado_TipoDeduccion]
GO
ALTER TABLE [dbo].[DeduccionXEmpleadoNoObligatoriaPorcentual]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleadoNoObligatoriaPorcentual_DeduccionXEmpleado1] FOREIGN KEY([Id])
REFERENCES [dbo].[DeduccionXEmpleado] ([Id])
GO
ALTER TABLE [dbo].[DeduccionXEmpleadoNoObligatoriaPorcentual] CHECK CONSTRAINT [FK_DeduccionXEmpleadoNoObligatoriaPorcentual_DeduccionXEmpleado1]
GO
ALTER TABLE [dbo].[DeduccionXEmpleadoXMes]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleadoXMes_PlanillaXMesxEmpleado] FOREIGN KEY([IdPlanillaXMesXEmpleado])
REFERENCES [dbo].[PlanillaXMesxEmpleado] ([Id])
GO
ALTER TABLE [dbo].[DeduccionXEmpleadoXMes] CHECK CONSTRAINT [FK_DeduccionXEmpleadoXMes_PlanillaXMesxEmpleado]
GO
ALTER TABLE [dbo].[DeduccionXEmpleadoXMes]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleadoXMes_TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([Id])
GO
ALTER TABLE [dbo].[DeduccionXEmpleadoXMes] CHECK CONSTRAINT [FK_DeduccionXEmpleadoXMes_TipoDeduccion]
GO
ALTER TABLE [dbo].[DetalleCorrida]  WITH CHECK ADD  CONSTRAINT [FK_DetalleCorrida_Corrida] FOREIGN KEY([IdCorrida])
REFERENCES [dbo].[Corrida] ([Id])
GO
ALTER TABLE [dbo].[DetalleCorrida] CHECK CONSTRAINT [FK_DetalleCorrida_Corrida]
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD  CONSTRAINT [FK_Empleados_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [FK_Empleados_Departamento]
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD  CONSTRAINT [FK_Empleados_Puestos] FOREIGN KEY([IdPuesto])
REFERENCES [dbo].[Puestos] ([Id])
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [FK_Empleados_Puestos]
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD  CONSTRAINT [FK_Empleados_TipoDocIdentidad] FOREIGN KEY([IdTipoDocumentoIdentidad])
REFERENCES [dbo].[TipoDocIdentidad] ([Id])
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [FK_Empleados_TipoDocIdentidad]
GO
ALTER TABLE [dbo].[FijaNoObligatoria]  WITH CHECK ADD  CONSTRAINT [FK_FijaNoObligatoria_DeduccionXEmpleado] FOREIGN KEY([Id])
REFERENCES [dbo].[DeduccionXEmpleado] ([Id])
GO
ALTER TABLE [dbo].[FijaNoObligatoria] CHECK CONSTRAINT [FK_FijaNoObligatoria_DeduccionXEmpleado]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleados] ([Id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_Empleados]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_SemanaPlanilla] FOREIGN KEY([IdSemanaPlanilla])
REFERENCES [dbo].[SemanaPlanilla] ([Id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_SemanaPlanilla]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_TipoJornada] FOREIGN KEY([IdTipoJornada])
REFERENCES [dbo].[TipoJornada] ([Id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_TipoJornada]
GO
ALTER TABLE [dbo].[MarcaDeAsistencia]  WITH CHECK ADD  CONSTRAINT [FK_MarcaDeAsistencia_Jornada] FOREIGN KEY([IdJornada])
REFERENCES [dbo].[Jornada] ([Id])
GO
ALTER TABLE [dbo].[MarcaDeAsistencia] CHECK CONSTRAINT [FK_MarcaDeAsistencia_Jornada]
GO
ALTER TABLE [dbo].[MovimientoDeduccion]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoDeduccion_DeduccionXEmpleado] FOREIGN KEY([IdDeduccionXEmpleado])
REFERENCES [dbo].[DeduccionXEmpleado] ([Id])
GO
ALTER TABLE [dbo].[MovimientoDeduccion] CHECK CONSTRAINT [FK_MovimientoDeduccion_DeduccionXEmpleado]
GO
ALTER TABLE [dbo].[MovimientoDeHoras]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoDeHoras_MarcaDeAsistencia] FOREIGN KEY([IdMarcaAsistencia])
REFERENCES [dbo].[MarcaDeAsistencia] ([Id])
GO
ALTER TABLE [dbo].[MovimientoDeHoras] CHECK CONSTRAINT [FK_MovimientoDeHoras_MarcaDeAsistencia]
GO
ALTER TABLE [dbo].[MovimientoDeHoras]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoDeHoras_MovimientoPlanilla] FOREIGN KEY([Id])
REFERENCES [dbo].[MovimientoPlanilla] ([Id])
GO
ALTER TABLE [dbo].[MovimientoDeHoras] CHECK CONSTRAINT [FK_MovimientoDeHoras_MovimientoPlanilla]
GO
ALTER TABLE [dbo].[MovimientoPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoPlanilla_PlanillaXSemanaxEmpleado] FOREIGN KEY([IdPlanillaXSemanaXEmpleado])
REFERENCES [dbo].[PlanillaXSemanaxEmpleado] ([Id])
GO
ALTER TABLE [dbo].[MovimientoPlanilla] CHECK CONSTRAINT [FK_MovimientoPlanilla_PlanillaXSemanaxEmpleado]
GO
ALTER TABLE [dbo].[MovimientoPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoPlanilla_TipoMovimientoPlanilla] FOREIGN KEY([IdTipoMovimientoPlanilla])
REFERENCES [dbo].[TipoMovimientoPlanilla] ([Id])
GO
ALTER TABLE [dbo].[MovimientoPlanilla] CHECK CONSTRAINT [FK_MovimientoPlanilla_TipoMovimientoPlanilla]
GO
ALTER TABLE [dbo].[PlanillaXMesxEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaXMesxEmpleado_MesPlanilla] FOREIGN KEY([IdMesPlanilla])
REFERENCES [dbo].[MesPlanilla] ([Id])
GO
ALTER TABLE [dbo].[PlanillaXMesxEmpleado] CHECK CONSTRAINT [FK_PlanillaXMesxEmpleado_MesPlanilla]
GO
ALTER TABLE [dbo].[PlanillaXSemanaxEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaXSemanaxEmpleado_Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleados] ([Id])
GO
ALTER TABLE [dbo].[PlanillaXSemanaxEmpleado] CHECK CONSTRAINT [FK_PlanillaXSemanaxEmpleado_Empleados]
GO
ALTER TABLE [dbo].[PlanillaXSemanaxEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaXSemanaxEmpleado_PlanillaXMesxEmpleado] FOREIGN KEY([IdPlanillaXMesXEmpleado])
REFERENCES [dbo].[PlanillaXMesxEmpleado] ([Id])
GO
ALTER TABLE [dbo].[PlanillaXSemanaxEmpleado] CHECK CONSTRAINT [FK_PlanillaXSemanaxEmpleado_PlanillaXMesxEmpleado]
GO
ALTER TABLE [dbo].[PlanillaXSemanaxEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaXSemanaxEmpleado_SemanaPlanilla] FOREIGN KEY([IdSemanaPlanilla])
REFERENCES [dbo].[SemanaPlanilla] ([Id])
GO
ALTER TABLE [dbo].[PlanillaXSemanaxEmpleado] CHECK CONSTRAINT [FK_PlanillaXSemanaxEmpleado_SemanaPlanilla]
GO
ALTER TABLE [dbo].[SemanaPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_SemanaPlanilla_MesPlanilla1] FOREIGN KEY([IdMesPlanilla])
REFERENCES [dbo].[MesPlanilla] ([Id])
GO
ALTER TABLE [dbo].[SemanaPlanilla] CHECK CONSTRAINT [FK_SemanaPlanilla_MesPlanilla1]
GO
/****** Object:  StoredProcedure [dbo].[sp_AsoDeduCreaPlanillaMesSemana]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_AsoDeduCreaPlanillaMesSemana] @outResultCode INT OUTPUT
	
AS
BEGIN
	INSERT INTO PlanillaXMesxEmpleado
		VALUES
		(
			0,
			0,
			(SELECT MAX(Id) AS ID FROM dbo.MesPlanilla)
		)

	INSERT INTO PlanillaXSemanaxEmpleado
		VALUES
		(
			0,
			(SELECT MAX(Id) AS ID FROM dbo.Empleados),
			(SELECT MAX(Id) AS ID FROM dbo.SemanaPlanilla),
			(SELECT MAX(Id) AS ID FROM dbo.MesPlanilla)

		)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BuscarIdJornada]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_BuscarIdJornada]
	@inValorDocumentoIdentidad INT
	, @outResultCode INT OUTPUT

--Este procedimiento agrega una marca de asistencia según la fecha brindada
AS

BEGIN
	-- Codigo para probar el SP

    --DECLARE
		
    --EXEC dbo.sp_AgregarMarcaAsistencia
		
	SET NOCOUNT ON;

	DECLARE @idEmpleado INT  
	= (SELECT E.id 
	FROM dbo.Empleado AS E
	WHERE 
		E.ValorDocumentoIdentidad = @inValorDocumentoIdentidad);

	DECLARE @idJornada INT
	= (SELECT J.id
	FROM dbo.Jornada AS J
	WHERE 
		J.IdEmpleado = @idEmpleado);

	RETURN @idJornada;

	SET NOCOUNT OFF;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarDepartamentos]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarDepartamentos]
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--      @inDocXML XML,
		--		@OutResultCode INT

		--EXEC sp_CargarDepartamentos
		--		@inDocXML XML,
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Departamento

				SELECT
					departamento.value('@Id','INT') AS id,
					departamento.value('@Nombre','VARCHAR(40)') AS nombre, 
					1 AS activo
			
				FROM  @inDocXML.nodes('Datos/Catalogos/Departamentos/Departamento') AS A(departamento)
				

			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarEliminarEmpleados]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarEliminarEmpleados]
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@OutResultCode INT

		--EXEC sp_CargarEliminarEmpleados
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			
			DECLARE @count INT;
			CREATE TABLE #EliminarTemporal(valorDocIdentidad INT);

			SELECT
			@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO #EliminarTemporal
					SELECT
						eliminarEmpleado.value('@ValorDocumentoIdentidad','INT') 
					FROM
					(
						SELECT  CAST(c AS XML) FROM
						OPENROWSET(
							BULK 'C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\Proyecto-2-Bases\Proyecto-2-Bases-de-Datos\SQL\StoredProcedures\CargaInformacion\Datos_Tarea2.xml',
							SINGLE_BLOB
						) AS T(c)
						) AS S(C)
						CROSS APPLY c.nodes('Datos/Operacion/EliminarEmpleado') AS A (eliminarEmpleado)

				SELECT @count = COUNT(*) FROM #EliminarTemporal;
				WHILE @count > 0
					BEGIN
						DECLARE @valorDocIdentidad INT = (SELECT TOP(1) valorDocIdentidad FROM #EliminarTemporal);
						UPDATE dbo.Empleado
						SET 
							Empleado.Activo = 0
						WHERE 
							Empleado.ValorDocumentoIdentidad = @ValorDocIdentidad;
						DELETE TOP (1) FROM #EliminarTemporal
						SELECT @count = COUNT(*) FROM #EliminarTemporal;
					END
				DROP TABLE #EliminarTemporal;
			COMMIT TRANSACTION TSaveMov;


		END TRY
		BEGIN CATCH
			IF @@Trancount>0 
				ROLLBACK TRANSACTION TSaveMov;
			INSERT INTO dbo.Errores	VALUES (
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				ERROR_MESSAGE(),
				GETDATE()
			);

			Set @OutResultCode=50005;
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarEmpleados]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarEmpleados]
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@OutResultCode INT

		--EXEC sp_CargarEmpleados
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Empleado
					SELECT

						empleado.value('@Nombre','VARCHAR(40)') AS nombre,
						empleado.value('@ValorDocumentoIdentidad','INT') AS valorDocIdentidad,
						CAST(empleado.value('@FechaNacimiento','VARCHAR(40)')AS DATE)  AS fechaNacimiento,
						empleado.value('@idPuesto','INT') AS idPuesto,
						empleado.value('@idDepartamento','INT') AS idDepartamento,
						empleado.value('@idTipoDocumentacionIdentidad','INT') AS idTipoDoc,
						(SELECT id FROM Usuarios AS U WHERE U.Pwd = empleado.value('@Password','INT')),
						1 AS activo
            
					FROM
						(
							SELECT CAST(c AS XML) FROM
							OPENROWSET(
								BULK 'C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\Proyecto-2-Bases\Proyecto-2-Bases-de-Datos\SQL\StoredProcedures\CargaInformacion\Datos_Tarea2.xml',
								SINGLE_BLOB
							) AS T(c)
							) AS S(C)
							CROSS APPLY c.nodes('Datos/Operacion/NuevoEmpleado') AS A (empleado)

				COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;

				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarFeriados]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarFeriados]
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inDocXML
		--		@OutResultCode INT

		--EXEC sp_CargarFeriados
		--		@inDocXMLM,
		--		@OutResultCode

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Feriados
					SELECT
						feriado.value('@Nombre','VARCHAR(64)') AS nombre,
						feriado.value('@Fecha','DATE') AS fecha
					FROM @inDocXML.nodes('Datos/Catalogos/Feriados/Feriado') AS A(feriado)
					
			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarMarcasAsistencia]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarMarcasAsistencia]
@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@OutResultCode INT

		--EXEC sp_CargarMarcasAsistencia
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO dbo.MarcasAsistencia
					SELECT

						marcaAsistencia.value('@FechaEntrada','SMALLDATETIME') AS fechaEntrada,
						marcaAsistencia.value('@FechaSalida','SMALLDATETIME') AS fechaSalida,
						(SELECT TOP 1 J.id 
						FROM dbo.Jornada AS J 
						WHERE J.IdEmpleado IN (SELECT TOP 1 E.id 
												FROM dbo.Empleado AS E 
												WHERE E.ValorDocumentoIdentidad = marcaAsistencia.value('@ValorDocumentoIdentidad','INT')))
					FROM
					(
						SELECT CAST(c AS XML) FROM
						OPENROWSET(
							BULK 'C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\Proyecto-2-Bases\Proyecto-2-Bases-de-Datos\SQL\StoredProcedures\CargaInformacion\Datos_Tarea2.xml',
							SINGLE_BLOB
						) AS T(c)
						) AS S(C)
						CROSS APPLY c.nodes('Datos/Operacion/MarcaDeAsistencia') AS A (marcaAsistencia)
			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
            
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarMesesSemanas]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CargarMesesSemanas]
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@OutResultCode INT

		--EXEC sp_CargarMesesSemanas
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY

			SELECT
			@OutResultCode=0 ;

			DECLARE @countFechas INT; DECLARE @countSemanas INT;
			CREATE TABLE #FechasTemporales(fecha DATE);
			CREATE TABLE #FechasSemana(fecha DATE);
			SET LANGUAGE Spanish 
			BEGIN TRANSACTION TSaveMov
				INSERT INTO  #FechasTemporales

					SELECT
						operacion.value('@Fecha','DATE') 
					FROM
					(
						SELECT  CAST(c AS XML) FROM
						OPENROWSET(
							BULK 'C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\Proyecto-2-Bases\Proyecto-2-Bases-de-Datos\SQL\StoredProcedures\CargaInformacion\Datos_Tarea2.xml',
							SINGLE_BLOB
						) AS T(c)
						) AS S(C)
						CROSS APPLY c.nodes('Datos/Operacion') AS A (operacion)
					WHERE
						(((SELECT DATEPART(WEEKDAY,operacion.value('@Fecha','DATE'))) = 4) OR ((SELECT DATEPART(WEEKDAY,operacion.value('@Fecha','DATE'))) = 5));


				SELECT @countFechas = COUNT(*) FROM #FechasTemporales;
				SELECT @countSemanas = COUNT(*) FROM #FechasTemporales;

				--Se crea la copia de la fechasTemporales
				INSERT INTO #FechasSemana

					SELECT fecha
					FROM #FechasTemporales

				--Se insertan los meses 
				DECLARE @fechaInicio DATE = (SELECT DATEADD(DAY,1,(SELECT TOP (1) fecha FROM #FechasTemporales)));
				DECLARE @mesActual INT = (SELECT DATEPART(MONTH, (SELECT TOP (1) fecha FROM #FechasTemporales)));

				WHILE @countFechas > 0

					BEGIN
						DECLARE @fechaActual DATE = (SELECT TOP(1) fecha FROM #FechasTemporales);

						IF (SELECT DATEPART(WEEKDAY,@fechaActual)) = 4 AND  @mesActual <> (SELECT DATEPART(MONTH,@fechaActual))
							BEGIN
								INSERT INTO MesPlanilla
								VALUES(
									@fechaInicio
									,@fechaActual
								)
								SET @fechaInicio = (SELECT DATEADD(DAY,1,@fechaActual));
								SET @mesActual = (SELECT DATEPART(MONTH,@fechaActual));
							END
						DELETE TOP (1) FROM #FechasTemporales
						SELECT @countFechas = COUNT(*) FROM #FechasTemporales;
					END
				DROP TABLE #FechasTemporales;

				--Se insertan las semanas

				WHILE @countSemanas > 0

					BEGIN
						DECLARE @fechaActualS DATE = (SELECT TOP(1) fecha FROM #FechasSemana);

						IF (SELECT DATEPART(WEEKDAY,@fechaActualS)) = 5
							BEGIN
								INSERT INTO SemanaPlanilla
								VALUES(
									@fechaActualS
									, (SELECT DATEADD(DAY,6,@fechaActualS))
									, (SELECT id FROM MesPlanilla AS MP WHERE(SELECT DATEPART(MONTH,MP.FechaIncio)) = (SELECT DATEPART(MONTH,@fechaActualS)))
								)
							END
						DELETE TOP (1) FROM #FechasSemana
						SELECT @countSemanas = COUNT(*) FROM #FechasSemana;
					END
				DROP TABLE #FechasSemana;
			COMMIT TRANSACTION TSaveMov;

		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarPuestos]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarPuestos]
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--      @inDocXML XML
		--		@OutResultCode INT
		
		--EXEC sp_CargarPuestos
		--		@inDocXML XML
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Puestos
					SELECT
						puesto.value('@Id','INT') AS id,
						puesto.value('@Nombre','VARCHAR(40)') AS Nombre,
						puesto.value('@SalarioXHora','FLOAT') AS salarioxHora,
						1 AS activo  
                
					FROM @inDocXML.nodes('Datos/Catalogos/Puestos/Puesto') AS T(puesto)
					

			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarTipoDeduccion]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarTipoDeduccion]
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inDocXML XML,
		--		@OutResultCode INT

		--EXEC sp_CargarTipoDeduccion
		--		@inDocXML,
		--		@OutResultCode

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;
			CREATE TABLE #TipoDeduccionTemporal(id int,esObligatorio VARCHAR(40),esPorcentual VARCHAR(40), valor FLOAT(3));
			DECLARE @count INT;
			INSERT INTO TipoDeduccion
				SELECT
					tipoDeduccion.value('@Id','INT') AS id,
					tipoDeduccion.value('@Nombre','VARCHAR(40)') AS nombre,
					tipoDeduccion.value('@Obligatorio','VARCHAR(40)') AS esObligatorio,
					tipoDeduccion.value('@Porcentual','VARCHAR(40)') AS esPorcentual

				FROM @inDocXML.nodes('Datos/Catalogos/Deducciones/TipoDeDeduccion') AS A (tipoDeduccion)

			INSERT INTO #TipoDeduccionTemporal
				SELECT
					tipoDeduccionTemp.value('@Id','INT') AS id,
					tipoDeduccionTemp.value('@Obligatorio','VARCHAR(40)') AS esObligatorio,
					tipoDeduccionTemp.value('@Porcentual','VARCHAR(40)') AS esPorcentual,
					tipoDeduccionTemp.value('@Valor','FLOAT(3)') AS valor

				FROM @inDocXML.nodes('Datos/Catalogos/Deducciones/TipoDeDeduccion') AS A (tipoDeduccionTemp)

			SELECT @count = COUNT(*) FROM #TipoDeduccionTemporal;

							WHILE @count > 0

								BEGIN
									IF EXISTS(SELECT TOP (1) * FROM #TipoDeduccionTemporal AS TD WHERE TD.esObligatorio = 'Si')
										BEGIN
											INSERT INTO DeduccionPorcentualObligatoria
											VALUES(
											(SELECT TOP (1)  id FROM #TipoDeduccionTemporal AS TD)
											, (SELECT TOP (1) valor FROM #TipoDeduccionTemporal AS TD)
											)
										END

									DELETE TOP (1) FROM #TipoDeduccionTemporal
									SELECT @count = COUNT(*) FROM #TipoDeduccionTemporal;
								END
					 
							DROP TABLE #TipoDeduccionTemporal;

			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarTipoDocIdentidad]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarTipoDocIdentidad]
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inDocXML XML
		--		@OutResultCode INT

		--EXEC sp_CargarTipoDocIdentidad
		--		@inDocXML, 
		--		@OutResultCode

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO TipoDocIdentidad

					SELECT
						tipodoc.value('@Id','INT') AS id,
						tipodoc.value('@Nombre','VARCHAR(40)') AS nombre,
						1 AS activo
                
					FROM @inDocXML.nodes('Datos/Catalogos/Tipos_de_Documento_de_Identificacion/TipoIdDoc') AS A(tipodoc)
					

			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarTipoJornada]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarTipoJornada]
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inDocXML XML
		--		@OutResultCode INT

		--EXEC sp_CargarTipoJornada
		--		@inDocXML,
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO TipoJornada

					SELECT
						tipoJornada.value('@Id','INT') AS id,
						tipoJornada.value('@Nombre','VARCHAR(40)') AS nombre,
						tipoJornada.value('@HoraEntrada','VARCHAR(40)') AS horaEntrada,
						tipoJornada.value('@HoraSalida','VARCHAR(40)') AS horaSalida
            
					FROM @inDocXML.nodes('Datos/Catalogos/TiposDeJornada/TipoDeJornada') AS A(tipoJornada)
					
			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarTipoJornadaProximaSemana]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarTipoJornadaProximaSemana]
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@OutResultCode INT

		--EXEC sp_CargarTipoJornadaProximaSemana
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				SET LANGUAGE SPANISH;

				INSERT INTO Jornada
					SELECT 
						tipoJornadaProximaSemana.value('@IdJornada','INT') AS idJornada,
						(SELECT E.Id FROM dbo.Empleado AS E WHERE E.ValorDocumentoIdentidad = tipoJornadaProximaSemana.value('@ValorDocumentoIdentidad','INT')),
						(SELECT Id FROM dbo.SemanaPlanilla WHERE FechaInicio = (SELECT DATEADD(DAY,1,(tipoJornadaProximaSemana.value('../@Fecha', 'DATE')))))

					FROM 
						(
						SELECT CAST(c AS XML) FROM
						OPENROWSET(
							BULK 'C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\Proyecto-2-Bases\Proyecto-2-Bases-de-Datos\SQL\StoredProcedures\CargaInformacion\Datos_Tarea2.xml',
							SINGLE_BLOB
						) AS T(c)
						) AS S(C)
						CROSS APPLY c.nodes('Datos/Operacion/TipoDeJornadaProximaSemana') AS A (tipoJornadaProximaSemana)

			COMMIT TRANSACTION TSaveMov;

		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarTipoMovimientoPlanilla]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarTipoMovimientoPlanilla]
		@inDocXML XML,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inDocXML XML,
		--		@OutResultCode INT

		--EXEC sp_CargarTipoMovimientoPlanilla
		--		@inDocXML,
		--		@OutResultCode

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO TipoMovimientoPlanilla

						SELECT
							tipoMovimiento.value('@Nombre','VARCHAR(50)') AS nombre
                
						FROM @inDocXML.nodes('Datos/Catalogos/TiposDeMovimiento/TipoMovimiento') AS A(tipoMovimiento)
						

			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CargarUsuarios]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CargarUsuarios]
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@OutResultCode INT

		--EXEC sp_CargarUsuarios
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Usuarios

				SELECT
					usuario.value('@username','VARCHAR(64)') AS username,
					usuario.value('@pwd','INT') AS pwd,
					usuario.value('@tipo','INT') AS tipo,
					1 AS activo
        
				FROM 
				(
					SELECT CAST(c AS XML) FROM
					OPENROWSET(
						BULK 'C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\Proyecto-2-Bases\Proyecto-2-Bases-de-Datos\SQL\StoredProcedures\CargaInformacion\Datos_Tarea2.xml',
						SINGLE_BLOB
					) AS T(c)
					) AS S(C)
					CROSS APPLY c.nodes('Datos/Usuarios/Usuario') AS A(usuario);

				INSERT INTO Usuarios
					SELECT

						empleado.value('@Username','VARCHAR(64)') AS username,
						empleado.value('@Password','INT') AS pwd,
						'2' AS tipo,
						1 AS activo
            
					FROM
						(
							SELECT CAST(c AS XML) FROM
							OPENROWSET(
								BULK 'C:\Users\Sebastian\Desktop\TEC\IIISemestre\Bases de Datos\Proyecto-2-Bases\Proyecto-2-Bases-de-Datos\SQL\StoredProcedures\CargaInformacion\Datos_Tarea2.xml',
								SINGLE_BLOB
							) AS T(c)
							) AS S(C)
							CROSS APPLY c.nodes('Datos/Operacion/NuevoEmpleado') AS A (empleado)

			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_EliminarEmpleados]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_EliminarEmpleados]
 	@inValorDocIdentidad INT
	, @OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inValorDocIdentidad
		--		, @OutResultCode INT

		--EXEC sp_CargarEliminarEmpleados
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
			@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				UPDATE dbo.Empleados
					SET 
						Empleados.Activo = 0
					WHERE 
						Empleados.ValorDocumentoIdentidad = @inValorDocIdentidad;
			COMMIT TRANSACTION TSaveMov;


		END TRY
		BEGIN CATCH
			IF @@Trancount>0 
				ROLLBACK TRANSACTION TSaveMov;
			INSERT INTO dbo.Errores	VALUES (
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				ERROR_MESSAGE(),
				GETDATE()
			);

			Set @OutResultCode=50005;
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarEmpleado]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_InsertarEmpleado]
	@inNombre VARCHAR(40)
	, @inValorDocumentoIdentidad INT
	, @inFechaNacimiento DATE
	, @inIdPuesto INT
	, @inIdDepartamento INT
	, @inIdTipoDocumentacionIdentidad INT
	, @inUsuario VARCHAR(64)
	, @inContraseña VARCHAR(64)
	, @OutResultCode INT OUTPUT

AS
BEGIN
		--DECLARE
		--	@inNombre VARCHAR(40)
		--	, @inValorDocumentoIdentidad INT
		--	, @FechaNacimiento DATE
		--	, @inIdPuesto INT
		--	, @inIdDepartamento INT
		--	, @inIdTipoDocumentacionIdentidad INT
		--	, @inUsuario
		--	, @inContraseña
		--	, @OutResultCode INT OUTPUT

		--EXEC sp_CargarEmpleados
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Empleados
					VALUES(
						@inNombre
						, @inValorDocumentoIdentidad
						, @inFechaNacimiento
						, @inIdPuesto
						, @inIdDepartamento
						, @inIdTipoDocumentacionIdentidad
						, @inUsuario
						, @inContraseña
						, 2
						, 1
					)
			COMMIT TRANSACTION TSaveMov;
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;

				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				Set @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;

END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarJornadaProximaSemana]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_InsertarJornadaProximaSemana]
		@inIdTipoJornada INT
		, @inValorDocIdentidad INT
		, @inIdSemanaPlanilla INT
		, @OutResultCode INT OUTPUT
	
AS
BEGIN
		--DECLARE
		--		@inIdTipoJornada INT
		--		, @inValorDocIdentidad INT
		--		, @inIdSemanaPlanilla INT
		--		, @OutResultCode INT OUTPUT

		--EXEC sp_CargarTipoJornadaProximaSemana
		--		@OutResultCode INT

		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0 ;

			BEGIN TRANSACTION TSaveMov
				INSERT INTO Jornada
					VALUES(
						@inIdTipoJornada
						, (SELECT E.Id FROM dbo.Empleados AS E WHERE E.ValorDocumentoIdentidad = @inValorDocIdentidad)
						, @inIdSemanaPlanilla
					)

			COMMIT TRANSACTION TSaveMov;

		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION TSaveMov;
				INSERT INTO dbo.Errores	VALUES (
					SUSER_SNAME(),
					ERROR_NUMBER(),
					ERROR_STATE(),
					ERROR_SEVERITY(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					ERROR_MESSAGE(),
					GETDATE()
				);

				SET @OutResultCode=50005;
				
		END CATCH;

		SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TipoDeJornadaProximaSemana]    Script Date: 18/06/2021 10:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_TipoDeJornadaProximaSemana]
	@inValorDocumentoIdentidad INT
	, @inIdNuevoTipoJornada INT
	, @outResultCode INT OUTPUT

--Este procedimiento edita un empleado el cual es buscado por su nombre, y se cambian sus atributos por los parametros
AS

BEGIN
	-- Codigo para probar el SP

    --DECLARE
		

    --EXEC dbo.sp_EditarEmpleado 
		

	SET NOCOUNT ON;


	UPDATE dbo.Jornada 

		SET 
			IdTipoJornada = @inIdNuevoTipoJornada

		WHERE
			Jornada.IdEmpleado = (SELECT E.id 
								 FROM dbo.Empleado AS E
								 WHERE 
									E.ValorDocIdentidad = @inValorDocumentoIdentidad);

	SET NOCOUNT OFF;

END
GO
USE [master]
GO
ALTER DATABASE [SistemaObrero] SET  READ_WRITE 
GO
