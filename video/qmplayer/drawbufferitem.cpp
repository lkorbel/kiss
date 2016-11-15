#include "drawbufferitem.h"
#include "buffertexture.h"
#include <QSGSimpleTextureNode>

/*!
 * \class DrawBufferItem
 * \brief QML item with direct access to draw buffer
 *
 * Item will draw texture with content from GL buffer
 * that is intended for external drawing (e.g. modify bits directly)
 */

DrawBufferItem::DrawBufferItem( QQuickItem* parent ) :
  QQuickItem( parent )
{
  setFlag( QQuickItem::ItemHasContents, true );
}

/*!
 * \brief full access to draw buffer
 * \return void pointer to buffer data
 *
 * Full access to drawing buffer. Use with caution!
 */
void* DrawBufferItem::drawBuffer()
{
  return mTexture->buffer();
}

/*!
 * \brief set size of drawing buffer
 * \param size dimensions of buffer
 *
 * Once buffer size is set, texture is generated and
 * item is ready to be rendered. Call this function each time
 * when dimension of buffer is change e.g. when about to
 * show image of different dimension then previous content
 */
void DrawBufferItem::setBufferSize( QSize size)
{
  mTextureSize = size;
  mTextureSizeChanged = true;
}

void DrawBufferItem::geometryChanged(const QRectF & newGeometry,
                                     const QRectF & oldGeometry)
{
  QQuickItem::geometryChanged( newGeometry, oldGeometry);
  if (newGeometry == oldGeometry)
    return;

  mRect = newGeometry;
  //TODO adjust mRect to keep mTexture size ratio
}

QSGNode* DrawBufferItem::updatePaintNode(QSGNode *, UpdatePaintNodeData*)
{
  if (!mTexture) //abort if no texture created
    return nullptr;

  if (mTextureSizeChanged) { //need to crete new texture
    mTexture = std::unique_ptr<BufferTexture>( new BufferTexture(mTextureSize) ); //TODO make_unique
    mTexture->setFiltering( QSGTexture::Linear );
    if (!mNode) //ensure node is created
      mNode = std::unique_ptr<QSGSimpleTextureNode>( new QSGSimpleTextureNode() ); //TODO make_unique
    mNode->setRect( mRect );
    mNode->setTexture( mTexture.get() );
    mNode->markDirty( QSGNode::DirtyGeometry | QSGNode::DirtyMaterial );
    mTextureSizeChanged = false;
  }

  if (mRectChanged) { //gemoetry changed
    mNode->markDirty( QSGNode::DirtyGeometry );
    mRectChanged = false;
  }

  if (mTexture->updateTexture()) { //material changed
    mTexture->bind();
    mNode->markDirty( QSGNode::DirtyMaterial );
  }

  return mNode.get();
}
