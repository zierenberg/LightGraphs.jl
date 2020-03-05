@testset "Parallel.ParallelDijkstra" begin
    g4 = path_digraph(5)
    d1 = float([0 1 2 3 4; 5 0 6 7 8; 9 10 0 11 12; 13 14 15 0 16; 17 18 19 20 0])
    d2 = sparse(float([0 1 2 3 4; 5 0 6 7 8; 9 10 0 11 12; 13 14 15 0 16; 17 18 19 20 0]))
    #Testing multisource On undirected Graph
    g3 = path_graph(5)
    d = [0 1 2 3 4; 1 0 1 0 1; 2 1 0 11 12; 3 0 11 0 5; 4 1 19 5 0]

    for g in testgraphs(g3)
        z  = shortest_paths(g, d, FloydWarshall())
        zp = @inferred(shortest_paths(g, collect(1:5), d, ParallelDijkstra()))
        @test all(isapprox(dists(z), dists(zp)))

        for i in 1:5
            state = shortest_paths(g, i, ShortestPaths.Dijkstra(all_paths=true));
            for j in 1:5
                if parents(zp)[i, j] != 0
                    @test parents(zp)[i, j] in state.predecessors[j]
                end
            end
        end

        z  = shortest_paths(g, d, FloydWarshall())
        zp = @inferred(shortest_paths(g, d, ParallelDijkstra()))
        @test all(isapprox(dists(z), dists(zp)))

        for i in 1:5
            state = shortest_paths(g, i, d, ShortestPaths.Dijkstra(all_paths=true))
            for j in 1:5
                if parents(zp)[i, j] != 0
                    @test parents(zp)[i, j] in state.predecessors[j]
                end
            end
        end

        z  = shortest_paths(g, FloydWarshall())
        zp = @inferred(shortest_paths(g, [1, 2], ParallelDijkstra()))
        @test all(isapprox(dists(z)[1:2, :], dists(zp)))

        for i in 1:2
            state = shortest_paths(g, i, ShortestPaths.Dijkstra(all_paths=true))
            for j in 1:5
                if parents(zp)[i, j] != 0
                    @test parents(zp)[i, j] in state.predecessors[j]
                end
            end
        end

        zp = shortest_paths(g, ParallelDijkstra)
        for i in vertices(g)
            @test ShortestPaths.dists(zp[i]) == shortest_paths(g, i, ShortestPaths.Dijkstra())
        end

    end


    #Testing multisource On directed Graph
    g3 = path_digraph(5)
    d = float([0 1 2 3 4; 5 0 6 7 8; 9 10 0 11 12; 13 14 15 0 16; 17 18 19 20 0])

    for g in testdigraphs(g3)
        z  = shortest_paths(g, d, FloydWarshall())
        zp = @inferred(shortest_paths(g, collect(1:5), d, ParallelDijkstra()))
        @test all(isapprox(dists(z), dists(zp)))

        for i in 1:5
            state = shortest_paths(g, i, ShortestPaths.Dijkstra(all_paths=true))
            for j in 1:5
                if parents(z)[i, j] != 0
                    @test parents(zp)[i, j] in state.predecessors[j]
                end
            end
        end

        z  = shortest_paths(g, FloydWarshall())
        zp = @inferred(shortest_paths(g, ParallelDijkstra()))
        @test all(isapprox(dists(z), dists(zp)))

        for i in 1:5
            state = shortest_paths(g, i, ShortestPaths.Dijkstra(all_paths=true))
            for j in 1:5
                if parents(zp)[i, j] != 0
                    @test parents(zp)[i, j] in state.predecessors[j]
                end
            end
        end

        z  = shortest_paths(g, FloydWarshall())
        zp = @inferred(shortest_paths(g, [1, 2], ParallelDijkstra()))
        @test all(isapprox(dists(z)[1:2, :], dists(zp)))

        for i in 1:2
            state = shortest_paths(g, i, ShortestPaths.Dijkstra(all_paths=true))
            for j in 1:5
                if parents(zp)[i, j] != 0
                    @test parents(zp)[i, j] in state.predecessors[j]
                end
            end
        end
    end
end
