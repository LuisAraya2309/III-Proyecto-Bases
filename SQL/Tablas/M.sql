USE [SistemaObrero]
GO

/****** Object:  Table [dbo].[MesPlanilla]    Script Date: 16/05/2021 12:23:04 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MesPlanilla](
	[Id] [int] NOT NULL,
	[FechaInicio] [varchar](64) NOT NULL,
	[FechaFin] [varchar](64) NOT NULL,
 CONSTRAINT [PK_MesPlanilla] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

