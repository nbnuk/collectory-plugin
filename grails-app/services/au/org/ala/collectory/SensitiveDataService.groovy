package au.org.ala.collectory

import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.apache.commons.httpclient.util.URIUtil

@Transactional
class SensitiveDataService {

    def grailsApplication

    /**
     * Return JSON representation of sensitive and/or high-resolution species held in data provider's datasets
     *
     * @param uid - uid of data provider
     */
    def getSensitiveSpeciesForDataProvider(def uid) {
        if (uid) {
            log.info("sensitive lists = " + grailsApplication.config.sensitive?.speciesLists)
            String sensitiveListsSOLR = '' //(grailsApplication.config.sensitive?.speciesLists ?: '').replace(",", "%20OR%20")
            def jsonSlurper = new JsonSlurper()
            def sensitiveListsArray = jsonSlurper.parseText(grailsApplication.config.sensitive?.speciesLists ?: '[]')
            sensitiveListsArray.each{
                sensitiveListsSOLR += (sensitiveListsSOLR > ''? "%20OR%20" : "")
                sensitiveListsSOLR += "(" + ((it.filter?: '') > ''? URIUtil.encodeWithinQuery(it.filter).replaceAll("%26","&").replaceAll("%3D","=").replaceAll("%3A",":") + "%20AND%20" : "") +
                        "species_list_uid:" + it.list + ")"
            }

            def url = grailsApplication.config.biocacheServicesUrl + "/occurrences/search?q=*:*&fq=data_provider_uid:" + uid + (sensitiveListsSOLR>''? "&fq=((" + sensitiveListsSOLR + ")+OR+(highresolution:true))" : "&fq=highresolution:true") + "&facets=names_and_lsid&pageSize=0&facet=on&flimit=-1"
            //&sort=names_and_lsid%20ASC"
            log.info("Get sensitive +/ high-resolution species for data provider from: " + url)
            def js = new JsonSlurper()
            def biocacheSearch = js.parse(new URL(url), "UTF-8")
            if (biocacheSearch.totalRecords == 0) {
                return biocacheSearch.facetResults
            }

            List sensitiveSpecies = []
            biocacheSearch.facetResults[0].fieldResult.each { result ->
                def spParts = result.label.split('\\|')
                if (spParts?.size()?:0 > 3) {
                    sensitiveSpecies << [
                            taxon     : spParts[0],
                            lsid      : spParts[1],
                            commonname: spParts[2],
                            records   : result.count
                    ]
                }
            }
            log.info("Resulting sensitive species = " + sensitiveSpecies.toString())
            return sensitiveSpecies

        } else {
            return null
        }
    }

    /**
     * Return JSON summary of records for a single species held in data provider's datasets
     *
     * @param lsid - uid of species
     * @param uid - uid of data provider
     */
    def getSpeciesRecordsForDataProvider(def lsid, def uid) {
        if (uid && lsid) {
            def url = grailsApplication.config.biocacheServicesUrl + "/occurrences/search?q=*:*&fq=data_provider_uid:" + uid + "&fq=taxon_concept_lsid:" + lsid + "&facets=data_resource_uid&pageSize=0&facet=on&flimit=-1"
            def js = new JsonSlurper()
            def biocacheSearch = js.parse(new URL(url), "UTF-8")
            log.info("biocacheSearch = " + biocacheSearch.toString())
            if (biocacheSearch.totalRecords == 0) {
                return biocacheSearch.facetResults
            }

            List datasetRecords = []
            biocacheSearch.facetResults[0].fieldResult.each { result ->
                def dsParts = result.fq.split(':')
                datasetRecords << [
                        label     : result.label,
                        dr_uid    : dsParts[1],
                        records   : result.count
                ]
            }
            return datasetRecords

        } else {
            return null
        }
    }

    /** Get summary of high resolution or sensitive records for a data provider. Not sure if this will be needed.
     *
     * @param uid
     * @return
     */
    def getHighResOrSensitiveRecordsForDataProvider(def uid) {
        if (uid) {
            //TODO - this doesn't use the sensitive lists approach in getSensitiveSpeciesForDataProvider() above. Consider this.
            def url = grailsApplication.config.biocacheServicesUrl + "/occurrences/search?q=*:*&fq=data_provider_uid:" + uid + "&fq=(sensitive:sensitive+OR+highresolution:true)" + "&facets=data_resource_uid&pageSize=0&facet=on&flimit=-1"
            def js = new JsonSlurper()
            def biocacheSearch = js.parse(new URL(url), "UTF-8")
            log.info("biocacheSearch = " + biocacheSearch.toString())
            if (biocacheSearch.totalRecords == 0) {
                return biocacheSearch.facetResults
            }

            List datasetRecords = []
            biocacheSearch.facetResults[0].fieldResult.each { result ->
                def dsParts = result.fq.split(':')
                datasetRecords << [
                        label     : result.label,
                        dr_uid    : dsParts[1],
                        records   : result.count
                ]
            }
            return datasetRecords

        } else {
            return null
        }
    }
}
