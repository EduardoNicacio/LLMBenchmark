-- Input validation function
CREATE FUNCTION dbo.CheckInputParameter
(
    @Parameter NVARCHAR(MAX),
    @MaxLength INT,
    @AllowNull BIT = 0,
    @ParamName NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT = 0;

    IF @AllowNull = 0 AND (@Parameter IS NULL OR LEN(@Parameter) = 0)
    BEGIN
        RAISERROR('Parameter cannot be null: %s', 16, 50001, @ParamName);
        SET @Result = 1;
    END
    ELSE IF @MaxLength > 0 AND LEN(@Parameter) > @MaxLength
    BEGIN
        RAISERROR('Parameter exceeds maximum length: %s (max %d characters)', 16, 50002, @ParamName, @MaxLength);
        SET @Result = 1;
    END

    RETURN @Result;
END
GO