USE [SistemaObrero]
GO

/****** Object:  Table [dbo].[MovimientoHora]    Script Date: 16/05/2021 12:23:25 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MovimientoHora](
	[id] [int] NOT NULL,
	[idMarcaAsistencia] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoHora] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MovimientoHora]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoHora_MarcasAsistencia] FOREIGN KEY([idMarcaAsistencia])
REFERENCES [dbo].[MarcasAsistencia] ([Id])
GO

ALTER TABLE [dbo].[MovimientoHora] CHECK CONSTRAINT [FK_MovimientoHora_MarcasAsistencia]
GO

