package com.app.news.controllers;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.InvalidMimeTypeException;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URLConnection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Component
public class FileValidator {

    private final Set<MediaType> whitelist;

    public FileValidator(List<MediaType> whitelist) {
        this.whitelist = new HashSet<>(whitelist);
    }

    private MediaType getMimeType(byte[] fileContent) throws InvalidMimeTypeException
    {
        String mimeType;
        try {
            ByteArrayInputStream byteStream = new ByteArrayInputStream(fileContent);
            mimeType = URLConnection.guessContentTypeFromStream(byteStream);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        if (mimeType == null)
            throw new InvalidMimeTypeException("", "No file type.");
        return MediaType.valueOf(mimeType);
    }

    public MediaType getValidMimeType(byte[] fileContent) throws InvalidMimeTypeException
    {
        MediaType mt = getMimeType(fileContent);
        if (!whitelist.contains(mt))
            throw new InvalidMimeTypeException(mt.toString(), "Invalid file type.");
        return mt;
    }
}
