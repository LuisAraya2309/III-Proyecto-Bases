USE [SistemaObrero]
GO

/****** Object:  Table [dbo].[DeduccionPorcentualObligatoria]    Script Date: 03/06/2021 04:58:06 p. m. ******/
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

ALTER TABLE [dbo].[DeduccionPorcentualObligatoria]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionPorcentualObligatoria_TipoDeduccion] FOREIGN KEY([Id])
REFERENCES [dbo].[TipoDeduccion] ([Id])
GO

ALTER TABLE [dbo].[DeduccionPorcentualObligatoria] CHECK CONSTRAINT [FK_DeduccionPorcentualObligatoria_TipoDeduccion]
GO

