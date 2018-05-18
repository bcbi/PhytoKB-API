# Given a leaf path generate its neighbors at different levels
# May 05, 2018


function get_names(leaf_arr::Array, dict_path::Dict, length_dict::Dict, dname_dict::Dict)
    num_leaves = length(leaf_arr)
    leaf_nam = Array{String}(num_leaves)
    for i=1:num_leaves
        leaf = "$(dname_dict[dict_path[leaf_arr[i]]])\:$(length_dict[leaf_arr[i]])"
        leaf_nam[i] = leaf
    end
    return leaf_nam
end

function get_neighbors(input_txn::String, input_lvl::Int64, path_dict::Dict)
    input_txn_path = path_dict[input_txn]
    input_txn_path_arr = split(input_txn_path, "\.")
    #println(input_txn_path[1:end-(2*input_lvl)])
    #println(input_txn_path)
    input_txn_parent = join(input_txn_path_arr[1:end-(2*input_lvl-1)], "\.")
    #=
    if input_txn_parent == "" || input_txn_parent == "0"
        println("Reached maximum depth")
    else
        println(input_txn_parent)
    end
    =#
    #println(ismatch(Regex("$input_txn_parent\.[0-9]+"), "0.1.3.2.2.3.2"))
    path_arr = collect(values(path_dict))
    neighbor = filter(x -> ismatch(Regex("$input_txn_parent.[0-9]+"), x), path_arr)
    #sort!(neighbor, rev=true)
    #println(neighbor)
    return neighbor, input_txn_parent
end


function create_newick_qry(idx_arr, path, lvl, olvl, str)
    #lvl = parse(Int64, split(path, "\.")[end-1])
    lvl += 1
    olvl += 1
    if lvl <= length(idx_arr)
        len = idx_arr[lvl]
        path = "$path\.$olvl"
        #println("\=\=\>$path")
        str = "$str\,$path"
        #println(str)
        for i in 1:len
            #println("$path\.$i")
            str = create_newick_qry(idx_arr, "$path\.$i", lvl, olvl, str)
        end
    end
    return str
end


function create_newick(nbr_arr, qry_arr, slvl, dict_path, length_dict, dname_dict)
    qstr = qry_arr[findfirst(map(x->length(split(x, "\.")), qry_arr), maximum(map(x->length(split(x, "\.")), qry_arr)))]
    qstr_len = length(split(qstr, "\."))

    nwk = ""
    i = parse(Int64, split(qstr, "\.")[end])
    prev_i = i
    while i >= slvl
        println(nwk)
        println("$i \=\> $prev_i \=\> $slvl \=\> $qstr")
        leaf = filter(x -> ismatch(Regex("$qstr"), x), nbr_arr)
        leaf = get_names(leaf, dict_path, length_dict, dname_dict)
        #println(leaf)
        if length(leaf) > 0
            #println("$i \=\> $prev_i \=\> $slvl \=\> $qstr")
            #println("$(length(leaf)) \=\>")
            if prev_i == i
                if nwk == ""
                    if length(leaf) != 1
                        nwk = "\(" * join(leaf, ",") * "\)\:$(length_dict[join(split(qstr, "\.")[1:end-1], "\.")])"
                    else
                        nwk = join(leaf, ",")
                    end
                else
                    if length(leaf) != 1
                        nwk = "\(" * join(leaf, ",") * "\)\:$(length_dict[join(split(qstr, "\.")[1:end-1], "\.")])" * "\," * nwk
                    else
                        nwk = join(leaf, ",") * "\," * nwk
                    end
                end
            else
                if qstr == "0\.1"
                    #println("2111")
                    nwk = join(leaf, ",") *  "\," * nwk
                else
                    if length(leaf) == 1
                        #println("3111")
                        nwk = "\(" * join(leaf, ",") *  "\," * nwk * "\)\:$(length_dict[join(split(qstr, "\.")[1:end-1], "\.")])"
                    else
                        nwk = "\($(join(leaf, ","))\)\:$(length_dict[join(split(qstr, "\.")[1:end-1], "\.")])" *  "\," * "\(" * nwk * "\)\:$(length_dict[join(split(qstr, "\.")[1:end-3], "\.")])"
                    end
                end
            end
            prev_i = i
            #println(nwk)
        end
        nbr_arr = filter(x -> !(ismatch(Regex("$qstr"), x)), nbr_arr)
        qry_arr = filter(x -> !(ismatch(Regex("$qstr"), x)), qry_arr)
        if length(qry_arr) > 0
            qstr = qry_arr[findfirst(map(x->length(split(x, "\.")), qry_arr), maximum(map(x->length(split(x, "\.")), qry_arr)))]
        else
            break
        end
        #str = join(split(str, "\.")[1:j-1], "\.")

        i = parse(Int64, split(qstr, "\.")[end])
        #println("\+\+$i")
    end
    return "\($nwk\)\;"
end

#######################################################################
# Load data from tree file stored as taxon and their respective paths #
#######################################################################


lengthFile = open("src/hd_tree_taxon_length.txt")
length_dict = Dict{Any, Any}()
for ln in eachline(lengthFile)
    ln = chomp(ln)
    path = split(ln, "\$")[1]
    len  = split(ln, "\$")[2]
    length_dict[path] = len
end

heightFile = open("src/hd_tree_taxon_height.txt")
height_dict = Dict{Any, Any}()
for ln in eachline(heightFile)
    ln = chomp(ln)
    path = split(ln, "\$")[1]
    hgt  = split(ln, "\$")[2]
    height_dict[path] = hgt
end

pathFile = open("src/hd_tree_taxon_path.txt")

path_dict = Dict{Any, Any}()
dict_path  = Dict{Any, Any}()
for ln in eachline(pathFile)
    ln   = chomp(ln)
    txn  = split(ln, "\$")[1]
    path = split(ln, "\$")[2]
    path_dict[txn] = path
    dict_path[path] = txn
end

drugFile = open("src/drugid_names.txt")

dname_dict  = Dict{Any, Any}()
for ln in eachline(drugFile)
    ln   = chomp(ln)
    txn  = split(ln, "\$")[1]
    name = split(ln, "\$")[2]
    name = replace(name, r"\,", "")
    dname_dict[txn] = name
end


function main(input_txn::String, input_lvl::String, length_dict, height_dict, dname_dict, dict_path)

    #nwk_str = "(mammal:0.14,turtle:0.02,(rayfinfish:0.25,(frog:0.01,salamander:0.01,crow:0.02)50:0.12)95:0.09);"

    #########################################
    # Input from user => drug/herb ID       #
    # Input from user => How many levels up #
    #########################################

    #input_txn = ARGS[1]
    #input_lvl = parse(Int64, ARGS[2])
    input_lvl = parse(Int64, input_lvl)

    nbr_arr, parent_path = get_neighbors(input_txn, input_lvl, path_dict)

    str = nbr_arr[findfirst(map(x->length(split(x, "\.")), nbr_arr), maximum(map(x->length(split(x, "\.")), nbr_arr)))]
    #println("str\:$str")
    max_lvl = parse(Int64, split(str, "\.")[end-1])
    inp_st = length(split(parent_path, "\.")) + 1
    #println(max_lvl)
    #println(inp_st)
    idx_arr = Any[]
    for i in inp_st:2:length(split(str, "\."))
        re = repeat("\\.\[0\-9\]\+\\.\[0\-9\]\+", Int64((i-1)/2))
        leaf = filter(x -> ismatch(Regex("0$re"), x), nbr_arr)
        idx = maximum(map(x->parse(Int64, split(x, "\.")[i]), leaf))
        push!(idx_arr, idx)
    end

    println(idx_arr)

    path = join(split(parent_path, "\.")[1:end-1], "\.")
    #println("path\:$path")
    #println("max_lvl\:$max_lvl")
    path != "0" ? olvl = parse(Int64, split(path, "\.")[end-1]) : olvl = 0
    slvl = parse(Int64, split(parent_path, "\.")[end])
    qry_str = create_newick_qry(idx_arr, path, 0, olvl, "")
    qry_str = qry_str[2:end]
    #println(qry_str)
    qry_arr = split(qry_str, "\,")

    nwk_str = create_newick(nbr_arr, qry_arr, slvl, dict_path, length_dict, dname_dict)
    #println(nwk_str)
    return nwk_str
end
