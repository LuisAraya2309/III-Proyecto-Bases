USE [SistemaObrero]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE sp_ProcesarMarcaAsistencia
		@nodoActual XML,
		@fechaActual DATE,
		@OutResultCode INT OUTPUT
	
AS
BEGIN
		

		SET NOCOUNT ON;
		BEGIN TRY

			SELECT
			@OutResultCode=0;
			--Marcas de Asistencia

			--Variables generales
			DECLARE @secItera INT, @secInicial INT,@secFinal INT,@produceError INT,@mensajeError VARCHAR(100);

			--Variable Tabla de Marcas Auxiliares
			DECLARE @MarcasAux TABLE (
				FechaInicio SMALLDATETIME,
				FechaFin SMALLDATETIME,
				IdJornada INT,
				Secuencia INT,
				ProduceError BIT)

			DECLARE @fechaInicio SMALLDATETIME , @fechaFin SMALLDATETIME, 
				@idEmpleado INT , @horasTrabajadas INT , @horaFinNormal TIME(0) , 
				@idTipoJornada INT , @horasExtra INT ,  @salarioXHora INT , @horasDeJornada INT,
				@horasExtrasDoble INT, @gananciasOrdinarias FLOAT, @ganaciasExtra FLOAT,
				@gananciasExtraDoble FLOAT,@idJornada INT;

			--Para generar los movimientos de las deducciones
			DECLARE @empleadosDeducciones TABLE(
				Id INT,
				FechaInicio DATE,
				FechaFin DATE,
				IdEmpleado INT,
				IdTipoDeduccion INT
			)

			DECLARE @idDE INT,@idEmpleadoDE INT, @fechaInicioDE DATE, @fechaFinDE DATE, @idTipoDeduccionDE INT,
			@iterarED INT, @montoDeduccionED FLOAT, @idMaximoPSE INT, @idMaximoPME INT,@idTipoMovimientoPlanillaDE INT,@idMesActual INT;


			INSERT INTO @MarcasAux
						SELECT
							marcaAsistencia.value('@FechaEntrada','SMALLDATETIME') AS fechaEntrada,
							marcaAsistencia.value('@FechaSalida','SMALLDATETIME') AS fechaSalida,
							(SELECT TOP 1 
								J.id 
							FROM dbo.Jornada AS J 
							WHERE 
								J.IdEmpleado IN (SELECT TOP 1 
													E.Id 
												FROM dbo.Empleados AS E 
												WHERE 
													E.ValorDocumentoIdentidad = marcaAsistencia.value('@ValorDocumentoIdentidad','INT'))),
							marcaAsistencia.value('@Secuencia','INT') AS Secuencia,
							marcaAsistencia.value('@ProduceError','BIT') AS ProduceError


						FROM @nodoActual.nodes('Operacion/MarcaDeAsistencia') AS T(marcaAsistencia)
					

					SELECT @secInicial = MIN(Secuencia) , @secFinal = MAX(Secuencia) FROM @MarcasAux;
					SELECT @secItera = @secInicial;

					WHILE @secItera<=@secFinal 
						BEGIN
							SELECT @fechaInicio  =  CONVERT(SMALLDATETIME,(SELECT TOP(1) FechaInicio FROM @MarcasAux));
							SELECT @fechaFin  =  CONVERT(SMALLDATETIME,(SELECT TOP(1) FechaFin FROM @MarcasAux));
							SELECT @idJornada  = (SELECT TOP(1) IdJornada FROM @MarcasAux);
							SELECT @idEmpleado  = (SELECT IdEmpleado FROM Jornada WHERE Jornada.Id = @idJornada);
							SELECT @horasTrabajadas  = DATEDIFF(HOUR,@fechaInicio,@fechaFin); --Calcula las horas trabajadas en la sesion
							SELECT @idTipoJornada  = (SELECT Jornada.IdTipoJornada FROM Jornada WHERE  Id =  @idJornada );
							SELECT @horasExtra  = 0, @horasExtrasDoble = 0; 
							SELECT @salarioXHora  = (SELECT 
														SalarioXHora 
													FROM Puestos 
													WHERE 
														Puestos.Id = (SELECT IdPuesto FROM Empleados WHERE Empleados.Id = @idEmpleado));


							SELECT @horasDeJornada = DATEDIFF(HOUR,
																(SELECT HoraInicio FROM TipoJornada WHERE Id = @idTipoJornada),
																(SELECT HoraFin FROM TipoJornada WHERE Id = @idTipoJornada)
																)



							SELECT @produceError  = (SELECT TOP(1) ProduceError FROM @MarcasAux);

							--Caso de Horass Extras Dobles
							SELECT 
								@horasExtrasDoble = @horasTrabajadas - @horasDeJornada,
								@horasExtra = 0,
								@horasTrabajadas = @horasDeJornada
							WHERE (DATEPART(WEEKDAY,@fechaActual) = 7) OR (@fechaActual IN (SELECT Fecha FROM Feriados))


							--Caso en el que solo se trabajen horas ordinarias y no hay extra
							SELECT
								@horasExtra = 0,
								@horasTrabajadas = @horasDeJornada
							WHERE @horasTrabajadas <= @horasDeJornada

							--Caso de Horas Extras Normales
							SELECT 
								@horasExtra = @horasTrabajadas-@horasDeJornada,
								@horasExtrasDoble = 0,
								@horasTrabajadas = @horasDeJornada
							WHERE (DATEPART(WEEKDAY,@fechaActual) <> 7) AND (@fechaActual NOT IN (SELECT Fecha FROM Feriados))
							
							
							--Verificamos si produce error
							IF @produceError = 1
								BEGIN
									SELECT @mensajeError = 'Hubo un error en el proceso de la marca de asistencia del empleado de Id: ' + CONVERT(VARCHAR,@idEmpleado);
									
									--AGREGAR A LA BITACORA EL ERROR
									INSERT INTO dbo.BitacoraErrores
										VALUES
										(
										@fechaActual,
										@mensajeError
										)
								
								END

							--CALCULAR LAS GANANCIAS POR HORA
							
							SELECT 
								@gananciasOrdinarias = (@salarioXHora*@horasTrabajadas),
								@ganaciasExtra = (@salarioXHora*1.5*@horasExtra),
								@gananciasExtraDoble = (@salarioXHora*2*@horasExtrasDoble)

							SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
							BEGIN TRANSACTION MarcaAsistenciaMov

							--Inserta la marca de asistencia
							INSERT INTO dbo.MarcaDeAsistencia (
								FechaEntrada,
								FechaSalida,
								IdJornada
							)
							VALUES
							(
								@fechaInicio,
								@fechaFin,                             
								@idJornada
							)
							
							--MOVIMIENTO DE HORAS ORDINARIAS
							INSERT INTO dbo.MovimientoPlanilla (
								Fecha,
								Monto,
								IdTipoMovimientoPlanilla,
								IdPlanillaXSemanaXEmpleado
							)
							VALUES
							(
								@fechaActual,
								@gananciasOrdinarias,
								1,
								(SELECT MAX(PS.Id) FROM PlanillaXSemanaXEmpleado AS PS WHERE PS.IdEmpleado = @idEmpleado)
							)

							INSERT INTO dbo.MovimientoDeHoras (
								Id,
								IdMarcaAsistencia,
								Horas
							)
							VALUES
							(
								(SELECT MAX(Id) FROM dbo.MovimientoPlanilla),
								(SELECT MAX(Id) FROM dbo.MarcaDeAsistencia),
								@horasTrabajadas
							)

							--MOVIMIENTO DE HORAS EXTRA NORMALES
							INSERT INTO dbo.MovimientoPlanilla (
								Fecha,
								Monto,
								IdTipoMovimientoPlanilla,
								IdPlanillaXSemanaXEmpleado
							)
							SELECT
								@fechaActual,
								@ganaciasExtra,
								2,
								(SELECT MAX(Id) AS id FROM PlanillaXSemanaXEmpleado AS PS WHERE PS.IdEmpleado = @idEmpleado )
							WHERE @horasExtra>0 AND @horasExtrasDoble = 0


							INSERT INTO dbo.MovimientoDeHoras (
								Id,
								IdMarcaAsistencia,
								Horas
							)
							SELECT
								(SELECT MAX(Id) FROM dbo.MovimientoPlanilla),
								(SELECT MAX(Id) FROM dbo.MarcaDeAsistencia),
								@horasExtra
							WHERE @horasExtra>0 AND @horasExtrasDoble = 0
								

							--MOVIMIENTO DE HORAS EXTRAS DOBLES
							INSERT INTO dbo.MovimientoPlanilla
							(
								Fecha,
								Monto,
								IdTipoMovimientoPlanilla,
								IdPlanillaXSemanaXEmpleado
							)
							SELECT 
								@fechaActual,
								@gananciasExtraDoble,
								3,
								(SELECT MAX(Id) AS id FROM PlanillaXSemanaXEmpleado  AS PS WHERE PS.IdEmpleado = @idEmpleado)
							WHERE @horasExtrasDoble>0 AND @horasExtra = 0

							INSERT INTO dbo.MovimientoDeHoras (
								Id,
								IdMarcaAsistencia,
								Horas
							)
							SELECT
								(SELECT MAX(Id) FROM dbo.MovimientoPlanilla),
								(SELECT MAX(Id) FROM dbo.MarcaDeAsistencia),
								@horasExtrasDoble
							WHERE @horasExtrasDoble>0 AND @horasExtra = 0


							--Actualiza la planilla x semana x empleado
							UPDATE dbo.PlanillaXSemanaxEmpleado
								SET SalarioBruto = dbo.CalcularUpdatePlanilla( SalarioBruto , @gananciasExtraDoble , @ganaciasExtra , @gananciasOrdinarias),
									SalarioNeto = dbo.CalcularUpdatePlanilla( SalarioNeto , @gananciasExtraDoble , @ganaciasExtra , @gananciasOrdinarias)
								
								WHERE Id = (SELECT MAX(PSE.Id) FROM dbo.PlanillaXSemanaxEmpleado AS PSE WHERE PSE.IdEmpleado = @idEmpleado );
							



							--SI ES JUEVES SE DEBEN APLICAR LAS DEDUCCIONES-----------------------------------------------------------------------------------------------------------------------

							IF DATEPART(WEEKDAY,@fechaActual) = 4     --Esto significa que es jueves
								BEGIN
									INSERT INTO @empleadosDeducciones(Id,FechaInicio,FechaFin,IdEmpleado,IdTipoDeduccion)
									SELECT 
										Id,
										FechaInicio,
										FechaFin,
										IdEmpleado,
										IdTipoDeduccion
									FROM dbo.DeduccionXEmpleado AS DE 
									WHERE DE.IdEmpleado = @idEmpleado;
									
									SELECT @iterarED = COUNT(*) FROM @empleadosDeducciones;
										
										WHILE @iterarED>0
											BEGIN
												SELECT @fechaInicioDE = (SELECT TOP(1) ED.FechaInicio FROM @empleadosDeducciones AS ED);
												SELECT @fechaFinDE = (SELECT TOP(1) ED.FechaFin FROM @empleadosDeducciones AS ED);
												SELECT @idEmpleadoDE = (SELECT TOP(1) ED.IdEmpleado FROM @empleadosDeducciones AS ED);
												SELECT @idDE = (SELECT TOP(1) ED.Id FROM @empleadosDeducciones AS ED);
												SELECT @idTipoDeduccionDE = (SELECT TOP(1) ED.IdTipoDeduccion FROM @empleadosDeducciones AS ED);
												SELECT @idMaximoPSE = (SELECT MAX(PS.Id) FROM PlanillaXSemanaxEmpleado AS PS WHERE PS.IdEmpleado = @idEmpleadoDE);
												SELECT @idMaximoPME = (SELECT MAX(PSE.IdPlanillaXMesXEmpleado) FROM dbo.PlanillaXSemanaxEmpleado AS PSE WHERE PSE.Id = @idMaximoPSE);
												--Verificamos  si son deducciones de ley obligatorias para el movimiento de planilla
												IF @idTipoDeduccionDE <> 1
													BEGIN
														SET @idTipoMovimientoPlanillaDE = 5;
													END
												ELSE
													BEGIN
														SET @idTipoMovimientoPlanillaDE = 4;
													END

												

												IF ((@fechaFinDE = NULL)) OR ((@fechaActual BETWEEN @fechaInicioDE AND @fechaFinDE)) OR @idTipoMovimientoPlanillaDE = 4
													BEGIN
														
														--Calculamos el monto  de la deduccion
														IF EXISTS (SELECT 1 FROM dbo.FijaNoObligatoria FNO WHERE FNO.Id = @idDE)
															BEGIN
																SET @montoDeduccionED = (SELECT FNO.Monto FROM dbo.FijaNoObligatoria FNO WHERE FNO.Id = @idDE);
															END
														ELSE 
															BEGIN
																IF EXISTS (SELECT 1 FROM dbo.DeduccionXEmpleadoNoObligatoriaPorcentual AS DENOP WHERE DENOP.Id = @idDE)
																	BEGIN
																		SET @montoDeduccionED = (SELECT DENOP.Porcentage FROM dbo.DeduccionXEmpleadoNoObligatoriaPorcentual AS DENOP WHERE DENOP.Id = @idDE);
																		SET @montoDeduccionED = @montoDeduccionED * (SELECT PS.SalarioBruto FROM dbo.PlanillaXSemanaxEmpleado AS PS WHERE PS.Id = @idMaximoPSE);
																	END
																ELSE
																	BEGIN
																		SET @montoDeduccionED = 0.095 * (SELECT PS.SalarioBruto FROM dbo.PlanillaXSemanaxEmpleado AS PS WHERE PS.Id = @idMaximoPSE);
																	END
															END
															 

														--Insertamos el movimiento de planilla
														INSERT INTO dbo.MovimientoPlanilla
															(
															Fecha,
															Monto,
															IdTipoMovimientoPlanilla,
															IdPlanillaXSemanaXEmpleado
															)
															VALUES
															(
															@fechaActual,
															@montoDeduccionED,
															@idTipoMovimientoPlanillaDE,
															@idMaximoPSE
															)

														--Insertamos el movimiento de Deduccion
														INSERT INTO dbo.MovimientoDeduccion
															(
															Id,
															IdDeduccionXEmpleado
															)
															VALUES
															(
															(SELECT MAX(MP.Id) FROM dbo.MovimientoPlanilla AS MP),
															@idDE
															)

														UPDATE dbo.PlanillaXSemanaxEmpleado
															SET SalarioNeto = dbo.CalcularSalarioNeto(SalarioNeto , @montoDeduccionED)
															WHERE Id = @idMaximoPSE AND IdEmpleado = @idEmpleadoDE;


														--Actualizar el total de deducciones segun el tipo
														 IF EXISTS (SELECT 1 FROM dbo.DeduccionXEmpleadoXMes
																	WHERE IdTipoDeduccion = @idTipoDeduccionDE AND
																	IdPlanillaXMesXEmpleado = @idMaximoPME)
															BEGIN
																UPDATE dbo.DeduccionXEmpleadoXMes
																SET TotalDeduccion = dbo.CalcularTotalDeducciones( TotalDeduccion , @montoDeduccionED)
																WHERE (
																	IdTipoDeduccion = @idTipoDeduccionDE AND
																	IdPlanillaXMesXEmpleado = @idMaximoPME
																)
															END
														ELSE
															BEGIN
																INSERT INTO dbo.DeduccionXEmpleadoXMes(
																	TotalDeduccion,
																	IdPlanillaXMesXEmpleado,
																	IdTipoDeduccion
																)
																VALUES(
																	@montoDeduccionED,
																	@idMaximoPME,
																	@idTipoDeduccionDE
																)
															END


													END --end del fecha between
													


													DELETE TOP(1) FROM @empleadosDeducciones;
													SELECT @iterarED = COUNT(*) FROM @empleadosDeducciones;
												

											END --end del while de empleadosDeducciones


										
										--Cierres de semana y mes
										SELECT @idMaximoPSE = (SELECT MAX(PS.Id) FROM PlanillaXSemanaxEmpleado AS PS WHERE PS.IdEmpleado = @idEmpleado);
										SELECT @idMaximoPME = (SELECT MAX(PSE.IdPlanillaXMesXEmpleado) FROM dbo.PlanillaXSemanaxEmpleado AS PSE WHERE PSE.Id = @idMaximoPSE);
										SELECT @idMesActual = (SELECT MAX(MP.Id) FROM dbo.MesPlanilla AS MP);
										--Aqui va el update de la mensual al cierre de semana

										UPDATE dbo.PlanillaXMesxEmpleado
												SET
													SalarioBruto = SalarioBruto + (SELECT PSE.SalarioBruto FROM dbo.PlanillaXSemanaxEmpleado AS PSE WHERE PSE.Id = @idMaximoPSE),
													SalarioNeto = SalarioNeto + (SELECT PSE.SalarioNeto FROM dbo.PlanillaXSemanaxEmpleado AS PSE WHERE PSE.Id = @idMaximoPSE)

												WHERE Id = @idMaximoPME;
											
										--Si es ultimo dia antes de cambiar de mes, creo el mes y despues la semana
										
										--Se crea el mes
										
										INSERT INTO dbo.PlanillaXMesxEmpleado
											(
											SalarioBruto,
											SalarioNeto,
											IdEmpleado,
											IdMesPlanilla
											)
											SELECT
												0.0,
												0.0,
												@idEmpleado,
												@idMesActual
											WHERE @fechaActual = DATEADD(DAY,-1,(SELECT MP.FechaIncio FROM dbo.MesPlanilla AS MP  WHERE MP.Id = @idMesActual))

										--Se crea la semana
										INSERT INTO dbo.PlanillaXSemanaxEmpleado
											(
											SalarioBruto,
											SalarioNeto,
											IdEmpleado,
											IdSemanaPlanilla,
											IdPlanillaXMesXEmpleado
											)

											SELECT
												0.0,
												0.0,
												@idEmpleado,
												(SELECT MAX(SP.Id) FROM dbo.SemanaPlanilla AS SP),
												(SELECT MAX(PME.Id) FROM dbo.PlanillaXMesxEmpleado AS PME WHERE IdEmpleado = @idEmpleado)
										

												
								END
							
							COMMIT TRANSACTION MarcaAsistenciaMov
							DELETE TOP (1) FROM @MarcasAux
							SELECT @secItera = @secItera + 1;

						END -- end del while
					
							
					DELETE FROM @MarcasAux;

					  --Termina la transaction
					
		END TRY
		BEGIN CATCH

				IF @@Trancount>0 
					ROLLBACK TRANSACTION MarcaAsistenciaMov;
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