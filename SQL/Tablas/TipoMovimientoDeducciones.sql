USE [SistemaObrero]
GO

/****** Object:  Table [dbo].[TipoMovimientoDeducciones]    Script Date: 03/06/2021 05:02:57 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TipoMovimientoDeducciones](
	[Id] [int] NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
 CONSTRAINT [PK_TipoMovimientoDeducciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TipoMovimientoDeducciones]  WITH CHECK ADD  CONSTRAINT [FK_TipoMovimientoDeducciones_TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([Id])
GO

ALTER TABLE [dbo].[TipoMovimientoDeducciones] CHECK CONSTRAINT [FK_TipoMovimientoDeducciones_TipoDeduccion]
GO

ALTER TABLE [dbo].[TipoMovimientoDeducciones]  WITH CHECK ADD  CONSTRAINT [FK_TipoMovimientoDeducciones_TipoMovimientoPlanilla] FOREIGN KEY([Id])
REFERENCES [dbo].[TipoMovimientoPlanilla] ([Id])
GO

ALTER TABLE [dbo].[TipoMovimientoDeducciones] CHECK CONSTRAINT [FK_TipoMovimientoDeducciones_TipoMovimientoPlanilla]
GO

