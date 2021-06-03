USE [SistemaObrero]
GO

/****** Object:  Table [dbo].[MarcasAsistencias]    Script Date: 03/06/2021 05:00:59 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarcasAsistencias](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [smalldatetime] NOT NULL,
	[FechaFin] [smalldatetime] NOT NULL,
	[IdJornada] [int] NOT NULL,
	[Ganancias] [int] NOT NULL,
	[HorasOrdinarias] [int] NOT NULL,
	[HorasExtras] [int] NOT NULL,
	[HorasExtrasDobles] [int] NOT NULL,
 CONSTRAINT [PK_MarcasAsistencias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MarcasAsistencias]  WITH CHECK ADD  CONSTRAINT [FK_MarcasAsistencias_Jornada] FOREIGN KEY([IdJornada])
REFERENCES [dbo].[Jornada] ([Id])
GO

ALTER TABLE [dbo].[MarcasAsistencias] CHECK CONSTRAINT [FK_MarcasAsistencias_Jornada]
GO

