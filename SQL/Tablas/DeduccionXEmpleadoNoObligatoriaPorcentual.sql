USE [SistemaObrero]
GO

/****** Object:  Table [dbo].[DeduccionXEmpleadoNoObligatoriaPorcentual]    Script Date: 03/06/2021 04:59:14 p. m. ******/
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

