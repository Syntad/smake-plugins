---@meta

---@diagnostic disable: duplicate-set-field

---@class compiler
---@field options table The compiler options used to generate the build command
compiler = {}

---Sets the compiler. Generally only used to change from `g++` to `gcc`
---@param compiler string The name of the compiler, defaults to `g++`
function compiler.compiler(compiler)end

---Specifies the c++ standard. This is equivalent to the `-std=<std>`
---@param std string The c++ standard
function compiler.standard(std) end

---Specifies the input path(s). This is equivalent to `<name1> <name2> ...`
---@param ... string The input paths
function compiler.input(...) end

---Inputs files from folders recursively. This is equivalent to `<folder>/*.<extension>` for any folders that contain 1 or more of a file with the specified extension.
---@param folder string The folder to search
---@param extension string? The extension to include, or 'cpp' if nil
function compiler.inputr(folder, extension) end

---Adds an include folder, possibly a library path, and possibly a library name. This is equivalent to `-I<includePath> -L<libPath> -l<libName>`
---@param includePath string The path to the include folder
---@param libPath? string The path to the lib folder
---@param libName? string The name of a lib file to load
---@overload fun(paths: table)
function compiler.include(includePath, libPath, libName) end

---Include multiple folders. This is equivalent to `-I<includePath>` for all paths
---@param paths table A table of include paths
function compiler.include(paths) end

---Adds a library folder and links all names
---@param libPath? string The path to the lib folder
---@param ... string The names to link
---@overload fun(names: table)
function compiler.link(libPath, ...) end

---Link multiple files. This is equivalent to `-l<name>` for all names
---@param names table A table of names to link
function compiler.link(names) end

---Link MacOS framework(s). This is equivalent to `-framework<frameworkName>` for all frameworks
---@param ... string A list of frameworks to link.
function compiler.framework(...) end

---Specifies the output path. This is equivalent to `-o<path>`
---@param path string The path to output to
function compiler.output(path) end

---Adds flags to the g++ command. This is equivalent to `<flags>`
---@param ... string The flags to append to the build command
function compiler.flags(...) end

---Runs the finalized build command
function compiler.compile() end

---Generates `compile_flags.txt` for clangd.
function compiler.generateCompileFlags() end

---Makes all functions global
function compiler:makeGlobal()end

compiler = compiler.compiler
standard = compiler.standard
input = compiler.input
inputr = compiler.inputr
include = compiler.include
link = compiler.link
framework = compiler.framework
output = compiler.output
flags = compiler.flags
compile = compiler.compile
generateCompileFlags = compiler.generateCompileFlags