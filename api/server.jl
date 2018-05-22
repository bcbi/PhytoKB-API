#Pkg.add("HTTP")
using HTTP
include("../src/path_neighbors.jl")
include("../src/data_processing.jl")



function run_server()

    query_dict = Dict()

    HTTP.listen() do request::HTTP.Request

        println("******************")
        @show request
        println("******************")

        uri = parse(HTTP.URI, request.target)
        query_dict = HTTP.queryparams(uri)

        headers = Dict{AbstractString,AbstractString}(
            "Server"            => "Julia/$VERSION",
            "Content-Type"      => "text/html; charset=utf-8",
            "Content-Language"  => "en",
            "Date"              => Dates.format(now(Dates.UTC), Dates.RFC1123Format),
            "Access-Control-Allow-Origin" => "*" )

        #return HTTP.Response(200, HTTP.Headers(collect(headers)), body = main(query_dict["id"], query_dict["level"], length_dict, height_dict, dname_dict, dict_path))
        input_lvl = parse(Int64, query_dict["level"])
        return HTTP.Response(200, HTTP.Headers(collect(headers)), body = get_subset_tree(query_dict["id"], nwk, input_lvl))

    end


end

run_server()
