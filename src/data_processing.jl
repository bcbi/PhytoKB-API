
nwk = readstring("src/hd_consensus_tree.nwk")

text = "dr_1327256"

levels_up = "2"

function find_start(str::String, taxon::String, levels_up::Int64)
    start = findfirst(taxon, str)[1]
    start_ = findprev("(", str, start)[1]
    counter = 0
    while counter < levels_up
        if str[start_-1] == ')'
            counter -= 1
            start_ -= 1
        elseif str[start_-1] == '('
            counter += 1
            start_ -= 1
        else
            start_ -= 1
        end
    end
    return start_


end

function find_end(str::String, taxon::String, levels_up::Int64)
    start = findfirst(taxon, str)[1]
    end_ = findnext(")", str, start)[1]
    counter = 0
    while counter < levels_up
        if str[end_+1] == '('
            counter -= 1
            end_ += 1
        elseif str[end_+1] == ')'
            counter += 1
            end_ += 1
        else
            end_ += 1
        end
    end
    return end_

end

function get_subset_string(str::String, taxon::String, levels_up::String)
    levels_up_int = parse(Int64, levels_up)
    start_ = find_start(str, taxon, levels_up_int)
    end_ = find_end(str, taxon, levels_up_int)
    return str[start_:end_] * ';'
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

function replace_name!(s::String, map::Dict{Any, Any})

    begin_ = findnext("_", s, 1)[1]

    while begin_ < length(s)
        end_ = findnext(":", s, begin_)
        global str_ = s[begin_-2:end_[1]-1]
        name = map[str_]

        s = s[1:begin_[1]-3] * name * s[end_[1]:length(s)]
        try
            begin_ = findnext("_", s, end_[1])[1]
        catch
            break
        end
    end

    return s

end

function main(str::String, taxon::String, levels_up::String, map::Dict{Any, Any})
    final_string = get_subset_string(str, taxon, levels_up)
    return replace_name!(final_string, map)
end
