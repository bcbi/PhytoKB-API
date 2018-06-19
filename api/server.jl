using HTTP
include("../src/newick_subset_parser.jl")



function run_server()

    query_dict = Dict()

    HTTP.listen("0.0.0.0", 8089, reauseaddr=true) do request::HTTP.Request

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

        return HTTP.Response(200, HTTP.Headers(collect(headers)), body = main(nwk, query_dict["id"], query_dict["level"], dname_dict))

    end
end

run_server()
