USE [SistemaObrero]
GO

/****** Object:  Table [dbo].[DeduccionXEmpleadoXMes]    Script Date: 03/06/2021 04:59:30 p. m. ******/
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

ALTER TABLE [dbo].[DeduccionXEmpleadoXMes]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleadoXMes_PlanillaXMesXEmpleado] FOREIGN KEY([IdPlanillaXMesXEmpleado])
REFERENCES [dbo].[PlanillaXMesXEmpleado] ([Id])
GO

ALTER TABLE [dbo].[DeduccionXEmpleadoXMes] CHECK CONSTRAINT [FK_DeduccionXEmpleadoXMes_PlanillaXMesXEmpleado]
GO

ALTER TABLE [dbo].[DeduccionXEmpleadoXMes]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleadoXMes_TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([Id])
GO

ALTER TABLE [dbo].[DeduccionXEmpleadoXMes] CHECK CONSTRAINT [FK_DeduccionXEmpleadoXMes_TipoDeduccion]
GO

