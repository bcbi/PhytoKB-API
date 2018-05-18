using DataFrames

lengthFile = open("hd_tree_taxon_length.txt")
len_df = DataFrame(Path = String[], Length = String[] )
for ln in eachline(lengthFile)
    ln = chomp(ln)
    path = split(ln, "\$")[1]
    len  = split(ln, "\$")[2]
    push!(len_df, [path len])
end

heightFile = open("hd_tree_taxon_height.txt")
h_df = DataFrame(Path = String[], Height = String[])
for ln in eachline(heightFile)
    ln = chomp(ln)
    path = split(ln, "\$")[1]
    hgt  = split(ln, "\$")[2]
    push!(h_df, [path hgt])
end

pathFile = open("hd_tree_taxon_path.txt")
path_df = DataFrame(Path = String[], ID = String[])
for ln in eachline(pathFile)
    ln   = chomp(ln)
    id  = split(ln, "\$")[1]
    path = split(ln, "\$")[2]
    push!(path_df, [path id])
end

drugFile = open("drugid_names.txt")
name_df = DataFrame(ID = String[], Name = String[])
for ln in eachline(drugFile)
    ln   = chomp(ln)
    id  = split(ln, "\$")[1]
    name = split(ln, "\$")[2]
    name = replace(name, r"\,", "")
    println(name)
    push!(name_df, [id name])
end


df = join(len_df, h_df, on = :Path, kind = :outer)
df = join(df, path_df, on = :Path, kind = :outer)
df = join(df, name_df, on = :ID, kind = :outer)
