gremlin> :> mgmt = graph.openManagement();
index= mgmt.makePropertyKey('taxonpath').dataType(String.class).cardinality(Cardinality.SINGLE).make();
mgmt.buildIndex('taxonpath', Vertex.class).addKey(index).buildCompositeIndex();
mgmt.commit();

gremlin> :> mgmt = graph.openManagement();
index= mgmt.makePropertyKey('identifier').dataType(String.class).cardinality(Cardinality.SINGLE).make();
mgmt.buildIndex('byIdentifier', Vertex.class).addKey(index).buildCompositeIndex();
mgmt.commit();


gremlin> :> mgmt = graph.openManagement();
target = mgmt.makePropertyKey('target').dataType(String.class).make();
strategy = mgmt.makePropertyKey('strategy').dataType(String.class).make();
target_type = mgmt.makePropertyKey('target_type').dataType(String.class).make();
mgmt.buildIndex('coverages', Vertex.class).addKey(target).addKey(strategy).addKey(target_type).buildCompositeIndex();
mgmt.commit();

g.V().hasLabel('coursewares').has('lc_enable',true).as('x').select('x').or(and(outE('has_category_code').inV().hasLabel('category_code').has('taxoncode','$F050005'),outE('has_category_code').inV().hasLabel('category_code').has('taxoncode','$RT0100'),outE('has_category_code').inV().hasLabel('category_code').has('taxoncode','$ON030000'))).select('x').or(outE('has_coverage').inV().hasLabel('coverage').has('target_type','Debug').has('target','qa'),outE('has_coverage').inV().hasLabel('coverage').has('target_type','Org').has('target','nd')).select('x').values('identifier')




gremlin> :> mgmt = graph.openManagement();taxoncode = mgmt.getPropertyKey('taxoncode');taxonpath = mgmt.getPropertyKey('taxonpath');mgmt.buildIndex('taxOnCodeAndPath',Vertex.class).addKey(taxoncode).addKey(taxonpath).buildMixedIndex("search");mgmt.commit();
==>null
gremlin> :> mgmt = graph.openManagement();taxoncode = mgmt.getPropertyKey('taxoncode');taxonpath = mgmt.getPropertyKey('taxonpath');mgmt.buildIndex('taxOnCodeAndPath1',Vertex.class).addKey(taxoncode).addKey(taxonpath, Mapping.STRING.asParameter()).buildMixedIndex("search");mgmt.commit();
==>null
gremlin>
