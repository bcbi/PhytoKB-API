
nwk = readstring("src/hd_consensus_tree.nwk")

text = "dr_1336926"

function get_subset_tree(taxon::String, newick_file::String, levels_up::Int64)
    f = findfirst(taxon, newick_file)

    start = first(f)
    end_ = last(f)

    while levels_up > 0 && start != 0
        ps = findprev("(", newick_file, start)
        pe = findnext(")", newick_file, end_)
        start = ps[1] - 1
        end_ = pe[1] + 1
        println(nwk[end_])
        #=
        if nwk[end_] == ':'
            add = findnext(",", newick_file, end_)
            println(add)
            global subset = newick_file[ps[1]:add[1]-1] * ");"
        else
        =#
            global subset = newick_file[ps[1]:pe[1]] * ";"
        #end
        levels_up -= 1
    end
    println(subset)
    return subset
end


#=
ss = get_subset_tree(text, nwk, 3)

open_parenthesis = 0
close_parenthesis = 0
for i in 1:length(ss)
    if ss[i] == '('
        open_parenthesis += 1
    elseif ss[i] == ')'
        close_parenthesis += 1
    end
end
println(open_parenthesis, close_parenthesis)

=#

#= TODO
- review number of parenthesis
- find and replace IDs by names
=#
