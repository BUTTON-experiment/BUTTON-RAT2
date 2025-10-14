add_library( buttonobj OBJECT
  # Append each .cc file
  Button.cc
  GeoButtonShieldFactory.cc
  ButtonDetectorFactory.cc
  ##GeoPMTFactoryBase.cc 
  ariadne.cc 
  azimuth_ks.cc 
  timefit.cc 
  distpmt.cc 
  likelihood.cc 
  goodness.cc 
  fit_param.cc 
  fourhitgrid.cc 
  pmt_geometry.cc 
  hitsel.cc 
  hits.cc 
  bonsaifit.cc 
  plato.cc 
  binfile.cc 
  centroid.cc
  searchgrid.cc
  BonsaiProc.cc
  GeoLinerHex.cc
  GeoLiner.cc
  ButtonDAQProc.cc
  VertexGen_PhotonRayWithAngularDist.cc
)

target_include_directories( buttonobj PUBLIC
  $<BUILD_INTERFACE:${BUTTON_INCLUDE_DIR}>
  $<INSTALL_INTERFACE:include>)

file(COPY include/ DESTINATION ${BUTTON_INCLUDE_DIR})

add_executable(button button.cpp)
target_link_libraries(button PUBLIC 
  buttonobj ${ROOT_LIBRARIES} ${Geant4_LIBRARIES} ${Ratpac_LIBRARIES})

set_target_properties(buttonobj button
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${BUTTON_LIBRARY_DIR}
    LIBRARY_OUTPUT_DIRECTORY ${BUTTON_LIBRARY_DIR})

install(TARGETS buttonobj button
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin)

install(DIRECTORY ${BUTTON_INCLUDE_DIR}
    DESTINATION ${CMAKE_INSTALL_PREFIX})
