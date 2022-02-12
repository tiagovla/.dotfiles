M = {}

M.token_map = {
    namespace = "LspNamespace",
    type = "LspType",
    class = "LspClass",
    enum = "LspEnum",
    interface = "LspInterface",
    struct = "LspStruct",
    typeParameter = "LspTypeParameter",
    parameter = "LspParameter",
    variable = "LspVariable",
    property = "LspProperty",
    enumMember = "LspEnumMember",
    event = "LspEvent",
    ["function"] = "LspFunction",
    method = "LspMethod",
    module = "LspModule",
    macro = "LspMacro",
    keyword = "LspKeyword",
    modifier = "LspModifier",
    comment = "LspComment",
    string = "LspString",
    number = "LspNumber",
    regexp = "LspRegexp",
    operator = "LspOperator",
}

M.modifiers_map = {
    declaration = "LspDeclaration",
    definition = "LspDefinition",
    readonly = "LspReadonly",
    static = "LspStatic",
    deprecated = "LspDeprecated",
    abstract = "LspAbstract",
    async = "LspAsync",
    modification = "LspModification",
    documentation = "LspDocumentation",
    defaultLibrary = "LspDefaultLibrary",
}

return M
